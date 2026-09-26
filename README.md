# RADMC-3D Docker Container

[![Build and Deploy RADMC-3D Container](https://github.com/Radonirinaunimi/radmc3d-docker/actions/workflows/deploy-container.yml/badge.svg)](https://github.com/Radonirinaunimi/radmc3d-docker/actions/workflows/deploy-container.yml)

A lightweight, multi-threaded container image for [RADMC-3D](https://github.com/dullemond/radmc3d-2.0), published on the GitHub Container Registry (`ghcr.io`).

## Highlights

- **Ultra-lightweight**: Multi-stage build on Alpine Linux with stripped binaries (~19 MB uncompressed, ~5.7 MB compressed download).
- **OpenMP acceleration**: Compiled with `-fopenmp` and default `OMP_STACKSIZE=64M` for multi-threaded Monte Carlo and ray tracing runs.
- **Flexible execution**: Supports passing subcommands (`mctherm`, `image`, `spectrum`, etc.) or custom commands (`sh`, etc.).
- **HPC & Cloud Ready**: Fully compatible with Docker, Podman, and Apptainer / Singularity.

---

## Getting Started

### Pulling from GHCR

```bash
docker pull ghcr.io/radonirinaunimi/radmc3d-docker:latest
```

### Running with Docker

Mount your model directory into `/work`:

```bash
# Print RADMC-3D version and usage options
docker run --rm ghcr.io/radonirinaunimi/radmc3d-docker:latest

# Run a thermal Monte Carlo simulation in the current directory
docker run --rm -v "$PWD":/work -w /work ghcr.io/radonirinaunimi/radmc3d-docker:latest mctherm

# Run with multi-threading (e.g. 8 threads)
docker run --rm -v "$PWD":/work -w /work ghcr.io/radonirinaunimi/radmc3d-docker:latest setthreads 8 mctherm

# Generate an image or spectrum
docker run --rm -v "$PWD":/work -w /work ghcr.io/radonirinaunimi/radmc3d-docker:latest image lambda 10
```

### Running with Apptainer / Singularity (HPC)

In HPC environments (e.g., SLURM clusters), convert or run directly via Apptainer:

```bash
# Direct run
apptainer run --bind "$PWD":/work --pwd /work docker://ghcr.io/radonirinaunimi/radmc3d-docker:latest mctherm

# Or pull into a local SIF file
apptainer build radmc3d.sif docker://ghcr.io/radonirinaunimi/radmc3d-docker:latest
apptainer run --bind "$PWD":/work --pwd /work radmc3d.sif mctherm
```

---

## Building Locally

Ensure Git submodules are checked out:

```bash
git clone --recurse-submodules https://github.com/Radonirinaunimi/radmc3d-docker.git
cd radmc3d-docker

# If already cloned without submodules:
git submodule update --init --recursive
```

Build the container image:

```bash
# Using Docker
docker build -t radmc3d:local .

# Using Podman
podman build -t radmc3d:local -f Containerfile .
```

---

## Repository Structure

```
├── .github/workflows/
│   └── deploy-container.yml   # GitHub Actions workflow to build and push to GHCR
├── radmc3d-2.0/               # Git submodule pointing to dullemond/radmc3d-2.0
├── .dockerignore              # Excludes unnecessary files from build context
├── .gitmodules                # Submodule configuration
├── Containerfile -> Dockerfile# Symlink for Podman compatibility
├── Dockerfile                 # Multi-stage build definition
├── docker-entrypoint.sh       # Smart CLI entrypoint wrapper
└── README.md                  # Documentation
```

---

## Updating the Submodule

To update the upstream RADMC-3D code to the latest commit:

```bash
git submodule update --remote radmc3d-2.0
git add radmc3d-2.0
git commit -m "Update radmc3d-2.0 submodule"
git push origin main
```

---

## License

RADMC-3D is created by Cornelis Dullemond and contributors under the [GPL-2.0 License](https://github.com/dullemond/radmc3d-2.0).
