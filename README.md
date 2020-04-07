# todo_lists.vim

A simple vim plugin for managing todo lists.

## Usage

The plugin provides a number of different commands for CRUD operations on your markdown todo lists. The main benefit of using the plugin is that it automatically 'propagates' changes to the relevant child/parent todos i.e. checking the last child todo will check the parent, deleting a todo will delete all the nested todos, etc.

The commands provided are

- `TodoListsCheckTodo`
- `TodoListsUncheckTodo`
- `TodoListsToggleTodo`
- `TodoListsInsertSiblingTodo`
- `TodoListsInsertChildTodo`
- `TodoListsDeleteTodo`

The commands are all quite self explanatory, but check out the doc file for a
full breakdown.

I'd also recommend setting up some mappings in your `ftplugin/markdown.vim`, such as

```
nnoremap <localleader>t :TodoListsToggleTodo<cr>
```

## Installation

I'd recommend using [vim-plug](https://github.com/junegunn/vim-plug) to install

```
Plug 'tompretty/vim-todo-lists'
```
