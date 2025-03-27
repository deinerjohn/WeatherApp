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
    var mockLocaldb: MockWeatherLocalDb!

    override func setUp() {
        super.setUp()
        mockAPIService = MockWeatherAPIService()
        mockLocaldb = MockWeatherLocalDb()
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
        mockLocaldb.storedWeatherData = ["Tokyo": mockWeather.toDomain()]
        
        do {
            
            let result = try await repository.fetchWeather(country: "Japan", city: "Tokyo", units: "metric")
            
            XCTAssertEqual(result.cityName, "Tokyo")
            XCTAssertEqual(result.countryName, "Japan")
            
        }
        

    }
    
    func testDeleteWeatherData() async throws {
        
        let mockWeather = Weather(
            weather: [WeatherCondition(main: "Clear", description: "Clear sky", icon: "01d")],
            main: MainWeather(
                temperature: Temperature(value: 20.5),
                pressure: Pressure(value: 1012),
                humidity: Humidity(value: 60),
                minTemperature: Temperature(value: 18.0),
                maxTemperature: Temperature(value: 22.0)
            ),
            wind: Wind(speed: Speed(value: 3.5), degree: 120),
            clouds: Clouds(coverage: 10),
            id: 1,
            countryName: "Spain",
            cityName: "Madrid"
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
