-- キャッシュされたモジュールを削除
package.loaded['arduineovim'] = nil
package.loaded['arduineovim/testModule'] = nil

-- モジュールを呼び出す
local simple = require('arduineovim')

-- 関数呼び出し
simple.test()
simple.callModule('test')
simple.callModule('')
