" Yank Paste Clipboard
" -- vim registers to system clipboard

function! YPGetSystemClipboard(rw)
	let clip_cmd = ''
	let clip_cmd_args = ''

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
		echom "No suitable clipboard command is found in the system 
					\ install one of xclip, xsel, tmux."
		return
	endif

	return clip_cmd.clip_cmd_args
endfunction

function! WClipboard(text)
	let clip_cmd = YPGetSystemClipboard('w')
	call system(clip_cmd, a:text)
endfunction

function! RClipboard(reg)
	let clip_cmd = YPGetSystemClipboard('r')
	let clipboard_content = system(clip_cmd)
	call setreg(a:reg, clipboard_content)
endfunction

command! -nargs=1 WClipboard
			\ call WClipboard(<q-args>)

command! -nargs=1 RClipboard
			\ call RClipboard(<args>)

nnoremap <silent> <Leader>y           :WClipboard <C-R>=getreg('"')<cr><cr><cr>
nnoremap <silent> <Leader>p           :RClipboard '"'<cr>
