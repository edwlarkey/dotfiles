vim.filetype.add({
  pattern = {
    ["${HOME}/txt/calendar/.*.txt"] = "textcal",
  },
})

-- local textcal_group = vim.api.nvim_create_augroup("textcal", { clear = true })

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = {
--     "*/txt/calendar/*",
--   },
--   group = textcal_group,
--   callback = function()
--     vim.wo.spell = true
--     vim.opt.hlsearch = true
--     print("hello")
--     vim.cmd([[
--       autocmd BufRead,BufNewFile */txt/calendar/* set filetype=textcal
--       autocmd BufRead,BufNewFile */txt/calendar/* exe '/'.strftime("%Y-%m-%d")
--       autocmd Filetype textcal setlocal ts=13 sw=13 expandtab
--     ]])
--   end,
-- })

vim.cmd([[
augroup textcal
  autocmd BufRead,BufNewFile */txt/calendar/* set filetype=textcal
  autocmd BufRead,BufNewFile */txt/calendar/* set spell
  autocmd BufRead,BufNewFile */txt/calendar/* set hlsearch
  autocmd BufRead,BufNewFile */txt/calendar/* exe '/'.strftime("%Y-%m-%d")
  autocmd Filetype textcal setlocal ts=13 sw=13 expandtab
augroup END
]])
--
--
-- if exists("b:current_syntax")
--     finish
-- endif
--
-- unlet! b:current_syntax
--
-- syntax case ignore
--
-- syn keyword textcalKeyword Natasha Vasya Misha
-- syn keyword textcalSpecial birthday
--
-- syn match textcalWeekday '\v[0-9]{4}\-[0-9]{2}\-[0-9]{2}\ {2}[MTWRF]\ {2}\:'
-- syn match textcalWeekend '\v[0-9]{4}\-[0-9]{2}\-[0-9]{2}\ {2}[S]\ {2}\:'
--
-- syn match textcalHash '#[A-Za-z0-9:\-_]*\w'
-- syn match textcalAt '@[A-Za-z0-9:\-_]*\w'
-- syn match textcalPlus '+[A-Za-z0-9:\-_]*\w'
--
-- highlight link textcalWeekday Constant
-- highlight link textcalWeekend Type
-- highlight link textcalHash Function
-- highlight link textcalAt Constant
-- highlight link textcalPlus Special
-- highlight link textcalKeyword Keyword
-- highlight link textcalSpecial PreProc
--
