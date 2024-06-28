package main

import (
	"io/ioutil"
	"os"
	"github.com/tidwall/gjson"
)

var ConfigJson =  []byte{}

func setConfigFile(f string) {
	configFile, _ := os.Open(f)
    cj, _ := ioutil.ReadAll(configFile)
	ConfigJson = cj;
}

func getProperty(p string) string {
    return gjson.GetBytes(ConfigJson, p).String()
}

func getConfig() string {
	return string(ConfigJson)
}
