import Cocoa

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService: Decodable {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
            
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        
        let finalURL = baseURL.appendingPathComponent("people/\(id)/")
        // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
        // 3 - Handle errors
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
        // 4 - Check for data
        guard let returnedData = data else { return completion(nil) }
        // 5 - Decode Person from JSON
        do {
            let decoder = JSONDecoder()
            let person = try decoder.decode(Person.self, from: returnedData)
            
            return completion(person)
        } catch {

            print(error.localizedDescription)
             
            return completion(nil)
        }
        
        }.resume()
    }

    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
      
      // 1 - Contact server
      URLSession.shared.dataTask(with: url) { (data, _, error) in
      // 3 - Handle errors
          if let error = error {
              print(error.localizedDescription)
              return completion(nil)
          }
      // 4 - Check for data
      guard let returnedData = data else { return completion(nil) }
      // 5 - Decode Person from JSON
      do {
          let decoder = JSONDecoder()
          let film = try decoder.decode(Film.self, from: returnedData)
          
          return completion(film)
      } catch {

          print(error.localizedDescription)
           
          return completion(nil)
      }
      
      }.resume()
    }

}

func fetchFilm(url: URL) {
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
          print(film)
      }
  }
}

// test case for Luke
SwapiService.fetchPerson(id: 1) { person in
  if let person = person {
      print(person)
    for film in person.films {
        fetchFilm(url: film)
    }
  }
}



