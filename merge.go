package main

import (
	"fmt"
	"log"
	"path/filepath"
	"strings"
)

func main() {
	mp4 := "Impregnation, No Strings Attached [674e2d97be0f7].mp4"
	srt := "Impregnation, No Strings Attached [674e2d97be0f7].srt"
	Mp4Inside(mp4, srt)
}
func Mp4Inside(mp4, srt string) string {
	baseMp4 := filepath.Base(mp4)
	baseSrt := filepath.Base(srt)
	//ffmpeg -i input.mp4 -vf "subtitles=subtitle.srt" output.mp4
	output := strings.Replace(baseMp4, filepath.Ext(baseMp4), "_subInside.mp4", -1)
	ff := fmt.Sprintf("ffmpeg -i \"%s\" -vf \"subtitles='%s'\" -c:v h264_nvenc -c:a libmp3lame -ac 1 -map_chapters -1 \"%s\"", baseMp4, baseSrt, output)
	log.Println(ff)
	return ff
}
