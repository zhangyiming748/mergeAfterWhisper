package main

import (
	"testing"
)

// go test -timeout 2000m -v -run TestInsideMerge

func TestMp4Inside(t *testing.T) {
	mp4 := "C:\\Users\\zen\\Github\\MultimediaProcessingPipeline\\test\\Impregnation, No Strings Attached [674e2d97be0f7].mp4"
	srt := "C:\\Users\\zen\\Github\\MultimediaProcessingPipeline\\test\\Impregnation, No Strings Attached [674e2d97be0f7].srt"
	Mp4Inside(mp4, srt)
}
