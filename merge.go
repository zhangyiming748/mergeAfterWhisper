package main

import (
	"io/fs"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/h2non/filetype"
)

func main() {
	files, err := FindAllFiles("/videos")
	if err != nil {
		log.Fatalf("必须挂载videos目录:%s\n", err)
	}
	for _, mp4 := range files {
		log.Println(mp4)
		srt := strings.Replace(mp4, filepath.Ext(mp4), ".srt", -1)
		if !isExist(srt) {
			log.Println("srt文件不存在:", srt)
			continue
		}
		Mp4Inside(mp4, srt)
	}
}

func Mp4Inside(mp4, srt string) string {
	//ffmpeg -i input.mp4 -vf "subtitles=subtitle.srt" output.mp4
	output := strings.Replace(mp4, filepath.Ext(mp4), "_subInside.mp4", -1)
	//ff := fmt.Sprintf("ffmpeg -i \"%s\" -vf \"subtitles='%s'\" -c:v h264_nvenc -c:a libmp3lame -ac 1 -map_chapters -1 \"%s\"", baseMp4, baseSrt, output)
	cmd := exec.Command("ffmpeg", "-i", mp4, "-vf", "subtitles='"+srt+"'", "-c:v", "h264_nvenc", "-c:a", "libmp3lame", "-ac", "1", "-map_chapters", "-1", output)
	log.Printf("cmd is %s\n", cmd.String())
	out, err := cmd.CombinedOutput()
	if err != nil {
		log.Printf("ffmpeg%s执行失败:%s\n", cmd.String(), string(out))
	}
	return output
}

func FindAllFiles(dirPath string) ([]string, error) {
	var files []string
	err := filepath.WalkDir(dirPath, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !d.IsDir() {
			f, _ := os.Open(path)
			head := make([]byte, 261)
			f.Read(head)
			if filetype.IsVideo(head) {
				files = append(files, path)
			} else {
				log.Println("Not a video file:", path)
			}
		}
		return nil
	})
	return files, err
}

func isExist(path string) bool {
	_, err := os.Stat(path)
	if err != nil {
		if os.IsNotExist(err) {
			return false
		}
		// 其他错误，例如权限问题等，这里也返回 false
		return false
	}
	return true
}
