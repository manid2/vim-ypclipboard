" Yank Paste Clipboard
" -- vim registers to system clipboard

function! WClipboard(clip_cmd, text)
	:call system(a:clip_cmd, a:text)
endfunction

function! RClipboard(clip_cmd, reg)
	let clipboard_content = system(a:clip_cmd)
	:call setreg(a:reg, clipboard_content)
endfunction

function! YPClipboard(rw)
	let clip_cmd = ''
	let clip_cmd_args = ''
	let def_reg = '"'

	" TODO: handle cases where xclip is not available use alternatives
	" i.e. xsel, tmux, gnu screen
	if executable('xclip')
		let clip_cmd = 'xclip'
		let clip_cmd_args = ' -selection clipboard'
		if a:rw == 'w'
			let clip_cmd_args .= ' -i'
		elseif a:rw == 'r'
			let clip_cmd_args .= ' -o'
		endif
	else
		echom "No suitable clipboard command is found in the system install one of xclip, xsel, tmux."
		return
	endif

	if a:rw == 'w'
		call WClipboard(clip_cmd.clip_cmd_args, getreg(def_reg))
	elseif a:rw == 'r'
		call RClipboard(clip_cmd.clip_cmd_args, def_reg)
	endif
endfunction

nnoremap <Leader>y           :call YPClipboard('w')<cr>
nnoremap <Leader>p           :call YPClipboard('r')<cr>

" TODO:
" * Add command to use YPCliboard.
" * Extend YPCliboard to copy/paste into/from any registers.
" * Add keymaps to copy useful meta data to clipboard such as:
"   copy file name, full file path, current directory, file directory, etc.
