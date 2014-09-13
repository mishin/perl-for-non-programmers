#!perl
use 5.14.0;
use Win32::GuiTest qw(:ALL);
use win32::Clipboard;

&get_informatica_win_and_activate();
&put_key_mouse();
&past_changed_text();

sub get_informatica_win_and_activate {
    my @windows =
      FindWindowLike( undef, "Informatica PowerCenter Designer ", "" );

    for (@windows) {
        print "$_>\t'", GetWindowText($_), "'\n";
        SetForegroundWindow($_);
    }
}

sub put_key_mouse {
    SendRawKey( VK_LMENU, KEYEVENTF_EXTENDEDKEY );
    SendKeys('{TAB}');
    SendRawKey( VK_LMENU, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP );
    MouseMoveAbsPix( 747, 560 );
    SendMouse('{LEFTCLICK}');
    MouseMoveAbsPix( 749, 560 );
    SendMouse('{LEFTCLICK}');
    MouseMoveAbsPix( 749, 560 );
    SendMouse('{LEFTCLICK}');
    MouseMoveAbsPix( 749, 560 );
    SendMouse('{RIGHTCLICK}');
    MouseMoveAbsPix( 819, 629 );
    SendMouse('{LEFTCLICK}');

}

sub past_changed_text {
    my $CLIP = Win32::Clipboard();

    SendKeys("^c");
    my $text = $CLIP->GetText;
# Shortcut_to_m_S01_STG_REF_EMPL
    $text =~ s|Shortcut_to_|SC_|g;
    # $text =~ s|DPRL|OPERATION_TYPE|g;    
    # $text =~ s|CCINF|PROD|g;
    $CLIP->Set($text);
    SendKeys("^v");
}
