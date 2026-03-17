Feature: API Testing with Karate DSL - JSONPlaceholder

  Background:
    * url 'https://jsonplaceholder.typicode.com'

    * def emailRegex = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'

    * def userSchema =
      """
      {
        id: '#number',
        name: '#string',
        username: '#string',
        email: '#regex ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$',
        address: '#object',
        phone: '#string',
        website: '#string',
        company:
        {
          name: '#string',
          catchPhrase: '#string',
          bs: '#string'
        }
      }
      """

  Scenario Outline: GET user by id - validate status and schema
    Given path 'users', userId
    When method get
    Then status 200
    And match response == userSchema
    And match response.email == '#regex ' + emailRegex

    Examples:
      | userId |
      | 1      |
      | 2      |
      | 3      |

  Scenario Outline: POST user - create with native JSON and validate response schema
    * def newUser =
      """
      {
        "name": "<name>",
        "username": "<username>",
        "email": "<email>"
      }
      """

    Given path 'users'
    And request newUser
    When method post
    Then status 201
    And match response ==
      """
      {
        id: '#number',
        name: '#(newUser.name)',
        username: '#(newUser.username)',
        email: '#(newUser.email)'
      }
      """
    And match response.email == '#regex ' + emailRegex

    Examples:
      | name            | username     | email                |
      | Nguyen Van A    | nguyenvana   | vana@example.com     |
      | Tran Thi B      | tranthib     | tran.b@example.org   |