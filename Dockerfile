# Dockerfile — ArchNesic v3 ISO builder (mount archlive/ at runtime)
FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed archiso && \
    pacman -Scc --noconfirm

WORKDIR /build

CMD ["sh", "-c", "mkarchiso -v . && cp out/*.iso /out/"]