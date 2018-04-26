UITableViewCell countdown
==========

功能特色
-------
完美解决 tableview上cell 倒计时。<br>
后台模式依然执行倒计时，最低的 CPU 消耗.<br>
#
要点
-------
在applicationDidEnterBackground方法中要允许在后台执行 GCD 定时器。<br>
在定时器调用界面，记得及时取消定时器，否则会导致当前对象无法释放。<br>

![效果图](https://github.com/JQWinner/DownTime/blob/master/demo.gif)
