// contagious list <reg> -n -o matrix.json
package cmd

import (
	"fmt"
	"os"
	"strings"

	"github.com/duffney/contagious/internal/ghcr"
	"github.com/duffney/contagious/tagStore"
	"github.com/spf13/cobra"
)

var listCmd = &cobra.Command{
	Use:   "list",
	Short: "",
	Args:  cobra.ExactArgs(1),
	Long:  ``,
	Run:   handleList,
}

var outputFormat string

func init() {
	listCmd.Flags().StringVarP(&outputFormat, "output", "o", "json", "Output format (json, table)")
	listCmd.Flags().BoolP("next-tag", "n", false, "Include next patch tag information")
}

func handleList(cmd *cobra.Command, args []string) {
	var username string
	registry := args[0]
	tagStore := tagStore.New()
	nTag, _ := cmd.Flags().GetBool("next-tag")

	if strings.Contains(registry, "ghcr.io") {
		username = strings.Split(registry, "/")[1]
	}

	images, err := ghcr.ListImages(username)
	if err != nil {
		os.Exit(1)
	}

	for _, img := range images {
		tagStore.AddImage(img)
	}

	switch outputFormat {
	case "json":
		jsonOutput, err := tagStore.GetJSON(nTag)
		if err != nil {
			os.Exit(1)
		}
		fmt.Println(jsonOutput)
	case "table":
		out, _ := tagStore.PrintTable(nTag)
		fmt.Println(out)
		return
	default:
		fmt.Println("Invalid output format")
		os.Exit(1)
	}
}
