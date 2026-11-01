my $sep = ($^O eq 'MSWin32') ? ';' : ':';
$ENV{TEXINPUTS} = "../vendor/resumes-CV/template-tzcan/styles//${sep}" . ($ENV{TEXINPUTS} || '');

# 指定xelatex引擎
$pdf_mode = 5;

# 指定输出目录
$out_dir = 'build';

# 启用 SyncTeX、非交互错误处理、file:line 日志
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
