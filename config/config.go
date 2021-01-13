package config

import (
	"io/ioutil"

	"github.com/caarlos0/env"
	"github.com/pkg/errors"
	"gopkg.in/yaml.v2"
)

const (
	DefaultConfigPath = "config.yaml"
)

type Config struct {
	ListenPort uint   `yaml:"listen_port"`
	ListenHost string `yaml:"listen_host"`

	DevelopmentMode bool `yaml:"dev_mode"`

	// TLS config ...
	// Log level ...
}

func LoadConfig(configPath string) (config Config, err error) {
	yamlConfig, err := ioutil.ReadFile(configPath)
	if err != nil {
		return config, errors.Wrap(err, "cannot read config file at "+configPath)
	}

	if err := yaml.Unmarshal(yamlConfig, &config); err != nil {
		return config, errors.Wrap(err, "cannot parse yaml config")
	}

	if err := env.Parse(&config); err != nil {
		return config, errors.Wrap(err, "could not read env variables")
	}

	return
}
