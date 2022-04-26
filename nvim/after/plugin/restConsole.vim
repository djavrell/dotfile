let s:vrc_auto_format_response_patterns = {
      \ 'json': 'python -m json.tool',
      \ 'xml': 'xmllint --format -',
    \}

let g:vrc_curl_opts = { '-sS': '', '-i': '' }

let g:vrc_allow_get_request_body = 1
