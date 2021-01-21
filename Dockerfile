FROM barichello/godot-ci

RUN wget https://downloads.tuxfamily.org/godotengine/3.2.3/Godot_v3.2.3-stable_linux_server.64.zip && \
    unzip Godot_v3.2.3-stable_linux_server.64.zip && \
    mv ./Godot_v3.2.3-stable_linux_server.64 /opt/godot-server

WORKDIR /game

COPY . ./src
RUN godot --path ./src --export-pack Linux/X11 /game/game.pck && rm -r ./src

EXPOSE 0.0.0.0:8787
CMD [ "/opt/godot-server", "--main-pack", "/game/game.pck" ]
