#fortune -s | cowsay -W 250 -f "$(cowsay -l | sed "1 d" | tr ' ' '\n' | shuf -n 1)" | lolcat
