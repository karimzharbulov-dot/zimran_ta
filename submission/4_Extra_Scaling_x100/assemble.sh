#!/bin/bash
# Сборка роликов из клипов по схеме: хук + тело 1 + тело 2
# Использование: ./assemble.sh <папка с клипами> <папка вывода>
IN="$1"; OUT="$2"; mkdir -p "$OUT"
clip() { ls "$IN"/*"$1".mp4 | head -1; }
while read -r VID COMBO HOOK B1 B2; do
  ffmpeg -nostdin -y -v error -i "$(clip $HOOK)" -i "$(clip $B1)" -i "$(clip $B2)" \
    -filter_complex "[0:v]setsar=1,fps=24,scale=720:1280[v0];[1:v]setsar=1,fps=24,scale=720:1280[v1];[2:v]setsar=1,fps=24,scale=720:1280[v2];\
[0:a]aresample=48000[a0];[1:a]aresample=48000[a1];[2:a]aresample=48000[a2];\
[v0][a0][v1][a1][v2][a2]concat=n=3:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart \
    "$OUT/Demo_${VID}_${COMBO}.mp4" && echo "$VID готов"
done << 'LIST'
V01 P1_A1_H1 P1_H1 P1_B1a P1_B1b
V02 P1_A2_H1 P1_H1 P1_B2a P1_B2b
V03 P1_A1_H3 P1_H3 P1_B1a P1_B1b
V04 P1_A2_H3 P1_H3 P1_B2a P1_B2b
V05 P2_A3_H2 P2_H2 P2_B3a P2_B3b
V06 P2_A4_H2 P2_H2 P2_B4a P2_B4b
V07 P2_A3_H4 P2_H4 P2_B3a P2_B3b
V08 P2_A4_H4 P2_H4 P2_B4a P2_B4b
LIST
