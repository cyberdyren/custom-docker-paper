    #   #   #
#     Build     #
    #   #   #
FROM openjdk:17-alpine AS build

LABEL maintainer="Max Oppermann <max@oppermann.fun> https://github.com/Max-42"

ARG version=1.18.1

RUN apk add curl jq git

WORKDIR /opt/minecraft

###############
RUN git clone https://github.com/PaperMC/Folia.git

WORKDIR /opt/minecraft/Folia

RUN chmod +x gradlew

RUN git config --global user.email "build@oppermann.fun" && git config --global user.name "Build Bot" 

RUN git config --global core.longpaths true

RUN ./gradlew applyPatches

RUN ./gradlew createReobfPaperclipJar


###############

#COPY ./getfolia.sh /

#RUN chmod +x gradlew

RUN chmod +x /getfolia.sh

RUN /getfolia.sh

#copy eula

COPY ./volumes/v18s1_server_data/eula.txt ./eula.txt

RUN ls -laR



    #   #   #
#   Enviroment  #
    #   #   #
        
FROM openjdk:17.0.1-bullseye AS runtime

LABEL maintainer="Max Oppermann <max@oppermann.fun> https://github.com/Max-42"

SHELL ["/bin/bash", "-c"]

WORKDIR /mc/

#Add docker User and Group
RUN addgroup --system --gid ${PGID:-9001} dockergroup
RUN useradd --shell "/bin/bash" --uid ${PUID:-9001} --gid ${PGID:-9001} v18s1user
#Copy executable .jar file from the build stage
COPY --from=build /opt/minecraft/build/libs/folia.jar /mc/folia.jar

#Copy entrypoint.sh (and all other files that might be added in the future)
COPY ./volumes/v18s1_server_data/ /var/tmp/server_volume_files/

RUN mv /var/tmp/server_volume_files/* /mc/
RUN chown -vR ${PUID:-9001}:${PGID:-9001} /mc/ && chmod -vR ug+rwx /mc/ && chown -vR ${PUID:-9001}:${PGID:-9001} /mc
RUN chown root:root /mc/entrypoint.sh && chmod 111 /mc/entrypoint.sh

VOLUME [ "/mc/" ]

RUN apt-get update && apt-get install -y openssh-server tmux htop iftop gosu

COPY ./config/sshd_config /etc/ssh/sshd_config

COPY ./volumes/v18s1_server_data/.gitignore /mc/

#ToDo
ARG sshrootpassword=y0urSecuReP4SsWoRD
ENV SSH_ROOT_PASSWORD=$sshrootpassword
#set the ssh root password
RUN echo "v18s1user:$sshrootpassword" | chpasswd 

COPY ./config/home/dotfiles /home/v18s1user/
RUN chmod 755 /home/v18s1user/.bashrc && chmod 755 /home/v18s1user/.profile

#Setup the ssh server
RUN mkdir /var/run/sshd
RUN /etc/init.d/ssh start

#Expose Network ports
EXPOSE 22/tcp

EXPOSE 25565/tcp
EXPOSE 25565/udp

#JVM Tuning Flags by aikar (Slightly modified)
ARG java_flags="-Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+UseCompressedOops  -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:-UseAdaptiveSizePolicy -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dfile.encoding=UTF-8 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true-XX:CompileThreshold=100"
ENV JAVAFLAGS=$java_flags

#Install gosu
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
	gosu nobody true

# Set memory size (Default 1G)
ARG memory_size=1G
ENV MEMORYSIZE=$memory_size

ENTRYPOINT ["/mc/entrypoint.sh"]