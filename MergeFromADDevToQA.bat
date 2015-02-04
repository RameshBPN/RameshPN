cd c:\
rd c:\MergeFromADDevToQA /s /q
mkdir MergeFromADDevToQA
cd c:\MergeFromADDevToQA
git init
git clone https://github.com/RameshBPN/RameshPN.git
cd c:\MergeFromADDevToQA\RameshPN
git config --global user.email "ramesh.botlaggunta@gmail.com"
git config --global user.name "RameshBPN"
git config remote.origin.url https://RameshBPN:1987oct17@github.com/RameshBPN/RameshPN.git
git checkout ADDev
git checkout QA
git merge ADDev
git push origin HEAD

