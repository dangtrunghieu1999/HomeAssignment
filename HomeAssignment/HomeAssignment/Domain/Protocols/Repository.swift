import Combine

protocol Repository {
    associatedtype T
    
    func fetch() -> AnyPublisher<T, Error>
    func save(_ item: T) -> AnyPublisher<Void, Error>
    func delete(_ item: T) -> AnyPublisher<Void, Error>
}

protocol PaginatedRepository: Repository {
    func fetch(page: Int, perPage: Int) -> AnyPublisher<[T], Error>
} 
