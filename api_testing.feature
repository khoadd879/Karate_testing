Feature: Demo Karate DSL - API Testing đơn giản với JSONPlaceholder
  # Karate KHÔNG cần viết Step Definitions như Cucumber truyền thống.
  # Mọi thứ đều được xử lý sẵn (built-in) — chỉ cần viết file .feature là chạy!

  Background:
    # Thiết lập Base URL một lần, dùng chung cho tất cả Scenario
    * url 'https://jsonplaceholder.typicode.com'

  Scenario: GET Request - Lấy thông tin user và kiểm tra bằng Fuzzy Matcher
    # Gọi API chỉ với 2 dòng: path + method — không cần thư viện HTTP nào thêm
    Given path 'users/1'
    When method get
    Then status 200

    # "Fuzzy Matcher" — killer feature của Karate!
    # Không cần so sánh giá trị cứng, chỉ cần kiểm tra KIỂU DỮ LIỆU hoặc điều kiện
    And match response.id == '#number'
    And match response.name == '#string'
    And match response.email == '#notnull'
    And match response.address == '#object'
    And match response.company.name == '#present'

  Scenario: POST Request - Tạo user mới với Native JSON
    # "Native JSON" — viết JSON trực tiếp trong file, KHÔNG cần parse, KHÔNG cần escape
    * def newUser =
      """
      {
        "name": "Nguyen Van A",
        "username": "nguyenvana",
        "email": "vana@example.com"
      }
      """

    # Gắn body và gọi POST — cú pháp cực kỳ ngắn gọn
    Given path 'users'
    And request newUser
    When method post
    Then status 201

    # Assert dữ liệu trả về khớp với dữ liệu đã gửi
    And match response.name == newUser.name
    And match response.username == newUser.username
    And match response.email == newUser.email
    # Server tự động tạo id cho record mới — kiểm tra id tồn tại và là số
    And match response.id == '#number'