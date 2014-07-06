util = require 'util'

describe 'sample app todo', ->

  beforeEach ->
    browser.get 'http://localhost:4000/#/todo-main'

  it 'should list todos' , ->
    element(By.id('opentodos')).click()

    todoList = element.all(By.repeater('todo in todos'))
    expect(todoList.count()).toEqual(4)