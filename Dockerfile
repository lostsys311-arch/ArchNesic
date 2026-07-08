# Dockerfile — build ArchNesic ISO in a container
FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed archiso mkinitcpio && \
    pacman -Scc --noconfirm

WORKDIR /build
COPY archlive/ ./archlive/

RUN cd archlive && mkarchiso -v .

CMD cp archlive/out/*.iso /out/
