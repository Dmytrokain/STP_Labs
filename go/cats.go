package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"sync"
)

// Base URL for The Cat API
const baseURL = "https://api.thecatapi.com/v1"

// Structs to parse JSON responses
type Image struct {
	URL string `json:"url"`
}

type Breed struct {
	Name   string `json:"name"`
	Origin string `json:"origin"`
}

type Category struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

// Fetch data from the API
func fetchData(endpoint string, result interface{}) error {
	url := fmt.Sprintf("%s/%s", baseURL, endpoint)
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("HTTP %d: %s", resp.StatusCode, http.StatusText(resp.StatusCode))
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	return json.Unmarshal(body, &result)
}

// Goroutine function to fetch and display random cat images
func fetchImages(wg *sync.WaitGroup) {
	defer wg.Done()

	var images []Image
	err := fetchData("images/search?limit=3", &images)
	if err != nil {
		fmt.Println("Error fetching images:", err)
		return
	}

	fmt.Println("\nRandom Cat Images:")
	for i, img := range images {
		fmt.Printf("%d. %s\n", i+1, img.URL)
	}
}

// Goroutine function to fetch and display cat breeds
func fetchBreeds(wg *sync.WaitGroup) {
	defer wg.Done()

	var breeds []Breed
	err := fetchData("breeds", &breeds)
	if err != nil {
		fmt.Println("Error fetching breeds:", err)
		return
	}

	fmt.Println("\nCat Breeds:")
	for i, breed := range breeds[:5] { // Display only the first 5 breeds
		fmt.Printf("%d. %s - Origin: %s\n", i+1, breed.Name, breed.Origin)
	}
}

// Goroutine function to fetch and display categories
func fetchCategories(wg *sync.WaitGroup) {
	defer wg.Done()

	var categories []Category
	err := fetchData("categories", &categories)
	if err != nil {
		fmt.Println("Error fetching categories:", err)
		return
	}

	fmt.Println("\nCategories:")
	for i, category := range categories {
		fmt.Printf("%d. %s\n", i+1, category.Name)
	}
}

// Main function
func main() {
	var wg sync.WaitGroup

	// Start concurrent goroutines
	wg.Add(3)
	go fetchImages(&wg)
	go fetchBreeds(&wg)
	go fetchCategories(&wg)

	// Wait for all goroutines to complete
	wg.Wait()

	fmt.Println("\nAll data fetched successfully!")
}
