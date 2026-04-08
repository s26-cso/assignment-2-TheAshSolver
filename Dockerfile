FROM archlinux:base-devel

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        qemu-user \
        riscv64-linux-gnu-gcc \
        riscv64-linux-gnu-gdb \
        vim \
    && pacman -Scc --noconfirm

WORKDIR /workspace
