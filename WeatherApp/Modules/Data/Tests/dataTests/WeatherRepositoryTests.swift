//
//  WeatherRepositoryTests.swift
//  Data
//
//  Created by Deiner Calbang on 3/24/25.
//

import XCTest
@testable import Data
@testable import Domain
@testable import Infrastructure

final class WeatherRepositoryTests: XCTestCase {
    
    var repository: WeatherRepository!
    var mockAPIService: MockWeatherAPIService!
    var mockLocaldb: MockSQLiteHelper!

    override func setUp() {
        super.setUp()
        mockAPIService = MockWeatherAPIService()
        mockLocaldb = MockSQLiteHelper()
        repository = WeatherRepositoryImpl(weatherApiService: mockAPIService, localDb: mockLocaldb, networkChecker: NetworkConnectionMonitor())
    }

    override func tearDown() {
        repository = nil
        mockAPIService = nil
        mockLocaldb = nil
        super.tearDown()
    }

    func testFetchWeather_Success() async throws {
        // Given
        let mockWeather = WeatherDTO(
            weather: [WeatherConditionDTO(main: "Clear", description: "Clear sky", icon: "01d")],
            main: MainWeatherDTO(temp: 20.5, pressure: 1012, humidity: 60, tempMin: 18.0, tempMax: 22.0),
            wind: WindDTO(speed: 3.5, deg: 120),
            clouds: CloudsDTO(all: 10),
            id: 1,
            cityName: "Tokyo",
            countryName: "Japan"
        )
        
        //Inject sample response and inject weatherData
        mockAPIService.mockResponse = mockWeather
        mockLocaldb.storedWeatherData = ["Tokyo": mockWeather]
        
        do {
            
            let result = try await repository.fetchWeather(country: "Japan", city: "Tokyo", units: "metric")
            
            XCTAssertEqual(result.cityName, "Tokyo")
            XCTAssertEqual(result.countryName, "Japan")
            
        }
        

    }
    
    func testDeleteWeatherData() async throws {
        
        let mockWeather = WeatherDTO(
            weather: [WeatherConditionDTO(main: "Sunny", description: "Clear sky", icon: "01d")],
            main: MainWeatherDTO(temp: 30.0, pressure: 1010, humidity: 40, tempMin: 28.0, tempMax: 32.0),
            wind: WindDTO(speed: 2.5, deg: 90),
            clouds: CloudsDTO(all: 5),
            id: 2,
            cityName: "Madrid",
            countryName: "Spain"
        )
        
        mockLocaldb.storedWeatherData = ["Madrid": mockWeather]
        
        do {
            try await mockLocaldb.deleteWeatherData(for: "Madrid")
            
            XCTAssertNil(mockLocaldb.storedWeatherData["Madrid"], "Madrid should be removed from the mock database")
        }
        
    }

    func testFetchWeather_Failure() async {
        // Given
        mockAPIService.mockError = URLError(.notConnectedToInternet)

        do {
            // When
            _ =  try await repository.fetchWeather(country: "Japan", city: "Tokyo", units: "metric")
            XCTFail("Expected an error but got success")
        } catch {
            // Then
            XCTAssertNotNil(error)
        }
    }

}
