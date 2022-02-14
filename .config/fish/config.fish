set fish_greeting 
set PATH $PATH ~/.poetry/bin ~/flutter/bin ~/android-studio/bin
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

function newdir -d "Create a directory and set CWD"
    command mkdir $argv
    if test $status = 0
        switch $argv[(count $argv)]
            case '-*'

            case '*'
                cd $argv[(count $argv)]
                return
        end
    end
end

function D -d "Aliase for docker-compose command"
  if test -z "$argv"
    set -l is_container_running (docker-compose ps -q)
    test -n "$is_container_running";
    and docker-compose ps
  else
    command docker-compose $argv
  end
end

function l
    ls -lh --color=auto --group-directories-first $argv
end

function la
    ls -lha --color=auto --group-directories-first $argv
end

function gitlog
    git log --graph --oneline --all
end

function s
    ss -lntup | column -t
end

function fish_prompt
  set -l exit_code $status

  # printf (set_color red)$USER(set_color brwhite)'@'(set_color yellow)(prompt_hostname)' '

  # test $SSH_TTY
  # and printf (set_color yellow)$USER(set_color --bold)'@'(set_color normal)(set_color yellow)(prompt_hostname)' '

  #test "$USER" = 'root'
  #and echo (set_color red)"#"

  # Print a yellow fork symbol when in a subshell
  set -l max_shlvl 2
  # test $TERM = "screen"; and set -l max_shlvl 2
  test $SSH_TTY;
  and set -l max_shlvl 1
  if test $SHLVL -gt $max_shlvl
    set_color yellow
    echo -n " ⑂"
    # set_color normal
  end

  if test $SSH_TTY; or test $USER != $LOGNAME
    set_color yellow
    test "$USER" = 'root'
    and set_color red
    printf ' '$USER(set_color --bold yellow)'@'(set_color normal)
  end

  if test $SSH_TTY
    printf (set_color yellow)(hostname)
  end

  printf ' '(set_color cyan)(prompt_pwd)' '

  # test "$USER" = 'root'
  # and echo -n (set_color red)"🟊"

  # Print a red dot for failed commands.
  if test $exit_code -ne 0
    set_color red  
  else
    set_color green
  end

  echo -n '❯'(set_color normal)' '

end

function fish_right_prompt -d "Write out the right prompt"
  if test -e 'docker-compose.yml'
    set_color magenta
    echo -n "D "
    set_color normal
  end

  if test $VIRTUAL_ENV
    set_color white
    echo -n V:
    set_color normal
    echo (string split / $VIRTUAL_ENV)[-1]" "
  end

  set -g __fish_git_prompt_showupstream auto
  set -g __fish_git_prompt_show_informative_status
  set -g __fish_git_prompt_use_informative_chars
  set -g __fish_git_prompt_color

  printf (fish_git_prompt (set_color blue)G(set_color normal):%s' ')

  # Allow for compatibility between fish 2.7 and 3.0
  set -l command_duration "$CMD_DURATIO$cmd_duration"

  if test -n "$command_duration" -a "$command_duration" -gt 5000
    set_color yellow
    test "$command_duration" -gt 10000; and set_color red
    echo '('(math -s0 '('$command_duration' / 60000)')':'(math -s0 '('$command_duration' % 60000) / 1000')'.'(math -s0 '('$command_duration' % 60000000) % 1000')') '
  end

  echo -n (set_color cyan)(date '+%H:%M:%S')

  set_color normal
end

