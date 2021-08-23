IRB.conf[:AUTO_INDENT] = true
IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:USE_COLORIZE] = true
IRB.conf[:PROMPT_MODE] = :DEFAULT

require 'irb/completion'

def clear
  system('clear')
end

def ri(*names)
  system(%{ri #{names.map {|name| name.to_s}.join(" ")}})
end
