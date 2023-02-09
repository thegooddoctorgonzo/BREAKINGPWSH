function git-AddComPush
{
    bash -c "git add ."
    bash -c "git commit -m '$date'"
    bash -c "git push origin main"
    
}