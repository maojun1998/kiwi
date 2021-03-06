#================
# FILE          : kiwiImageBuildFactory.pm
#----------------
# PROJECT       : openSUSE Build-Service
# COPYRIGHT     : (c) 2013 SUSE LLC
#               :
# AUTHOR        : Robert Schweikert <rjschwei@suse.com>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : Unit test implementation for the KIWIImageBuildFactory
#               : module.
#               :
# STATUS        : Development
#----------------
package Test::kiwiImageBuildFactory;

use strict;
use warnings;

use Common::ktLog;
use Common::ktTestCase;
use base qw /Common::ktTestCase/;

use KIWICommandLine;
use KIWIImage;
use KIWIImageBuildFactory;
use KIWIOverlay;
use KIWIXML;

#==========================================
# Constructor
#------------------------------------------
sub new {
    # ...
    # Construct new test case
    # ---
    my $this = shift -> SUPER::new(@_);
    $this -> {dataDir} = $this -> getDataDir() . '/kiwiImageBuildFactory';

    return $this;
}

#==========================================
# test_ctor
#------------------------------------------
sub test_ctor {
    # ...
    # Test the KIWIImageBuildFactory
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $confDir = $this -> {dataDir};
    my $cmdL = $this -> __getCommandLineObj();
    my $xml = $this -> __getXMLObj($confDir, $cmdL);
        my $image = $this -> __getImageObj($xml, $cmdL);
    my $bFact = KIWIImageBuildFactory -> new($xml, $cmdL, $image);
    my $msg = $kiwi -> getMessage();
    $this -> assert_str_equals('No messages set', $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('none', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('No state set', $state);
    # Test this condition last to get potential error messages
    $this -> assert_not_null($bFact);
    return;
}

#==========================================
# test_ctor_invalidArg1
#------------------------------------------
sub test_ctor_invalidArg1 {
    # ...
    # Test the KIWIImageBuildFactory with invalid first argument
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $bFact = KIWIImageBuildFactory -> new('foo');
    my $msg = $kiwi -> getMessage();
    my $expected = 'KIWIImageBuildFactory: expecting KIWIXML object as '
        . 'first argument.';
    $this -> assert_str_equals($expected, $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('error', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('failed', $state);
    # Test this condition last to get potential error messages
    $this -> assert_null($bFact);
    return;
}

#==========================================
# test_ctor_invalidArg2
#------------------------------------------
sub test_ctor_invalidArg2 {
    # ...
    # Test the KIWIImageBuildFactory with invalid second argument
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $confDir = $this -> {dataDir};
    my $cmdL = $this -> __getCommandLineObj();
    my $xml = $this -> __getXMLObj($confDir, $cmdL);
    my $bFact = KIWIImageBuildFactory -> new($xml, 'foo');
    my $msg = $kiwi -> getMessage();
    my $expected = 'KIWIImageBuildFactory: expecting KIWICommandLine object '
        . 'as second argument.';
    $this -> assert_str_equals($expected, $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('error', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('failed', $state);
    # Test this condition last to get potential error messages
    $this -> assert_null($bFact);
    return;
}

#==========================================
# test_ctor_invalidArg3
#------------------------------------------
sub test_ctor_invalidArg3 {
    # ...
    # Test the KIWIImageBuildFactory with invalid third argument
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $confDir = $this -> {dataDir};
    my $cmdL = $this -> __getCommandLineObj();
    my $xml = $this -> __getXMLObj($confDir, $cmdL);
    my $bFact = KIWIImageBuildFactory -> new($xml, $cmdL, 'foo');
    my $msg = $kiwi -> getMessage();
    my $expected = 'KIWIImageBuildFactory: expecting KIWIImage object '
        . 'as third argument.';
    $this -> assert_str_equals($expected, $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('error', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('failed', $state);
    # Test this condition last to get potential error messages
    $this -> assert_null($bFact);
    return;
}

#==========================================
# test_ctor_noArg1
#------------------------------------------
sub test_ctor_noArg1 {
    # ...
    # Test the KIWIImageBuildFactory with no argument
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $bFact = KIWIImageBuildFactory -> new();
    my $msg = $kiwi -> getMessage();
    my $expected = 'KIWIImageBuildFactory: expecting KIWIXML object as '
        . 'first argument.';
    $this -> assert_str_equals($expected, $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('error', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('failed', $state);
    # Test this condition last to get potential error messages
    $this -> assert_null($bFact);
    return;
}

#==========================================
# test_ctor_noArg2
#------------------------------------------
sub test_ctor_noArg2 {
    # ...
    # Test the KIWIImageBuildFactory with no second argument
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $confDir = $this -> {dataDir};
    my $cmdL = $this -> __getCommandLineObj();
    my $xml = $this -> __getXMLObj($confDir, $cmdL);
    my $bFact = KIWIImageBuildFactory -> new($xml);
    my $msg = $kiwi -> getMessage();
    my $expected = 'KIWIImageBuildFactory: expecting KIWICommandLine object '
        . 'as second argument.';
    $this -> assert_str_equals($expected, $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('error', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('failed', $state);
    # Test this condition last to get potential error messages
    $this -> assert_null($bFact);
    return;
}

#==========================================
# test_ctor_noArg3
#------------------------------------------
sub test_ctor_noArg3 {
    # ...
    # Test the KIWIImageBuildFactory with no third argument
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $confDir = $this -> {dataDir};
    my $cmdL = $this -> __getCommandLineObj();
    my $xml = $this -> __getXMLObj($confDir, $cmdL);
    my $bFact = KIWIImageBuildFactory -> new($xml, $cmdL);
    my $msg = $kiwi -> getMessage();
    my $expected = 'KIWIImageBuildFactory: expecting KIWIImage object '
        . 'as third argument.';
    $this -> assert_str_equals($expected, $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('error', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('failed', $state);
    # Test this condition last to get potential error messages
    $this -> assert_null($bFact);
    return;
}

#==========================================
# test_expectContBuilder
#------------------------------------------
sub test_expectContBuilder {
    # ...
    # Test the getImageBuilder method
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $confDir = $this -> {dataDir};
    my $cmdL = $this -> __getCommandLineObj();
    my $xml = $this -> __getXMLObj($confDir, $cmdL);
        $xml -> setBuildType('lxc');
        my $image = $this -> __getImageObj($xml, $cmdL);
    my $tmpDir = $this -> createTestTmpDir();
    $cmdL -> setImageTargetDir($tmpDir);
    my $bFact = KIWIImageBuildFactory -> new($xml, $cmdL, $image);
    $this -> assert_not_null($bFact);
    my $builder = $bFact -> getImageBuilder();
    my $msg = $kiwi -> getMessage();
    $this -> assert_str_equals('No messages set', $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('none', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('No state set', $state);
    # Test this condition last to get potential error messages
    $this -> assert_str_equals(ref($builder), 'KIWIContainerBuilder');
    $this ->  removeTestTmpDir();
    return;
}

#==========================================
# test_expectTarBuilder
#------------------------------------------
sub test_expectTarBuilder {
    # ...
    # Test the getImageBuilder method
    # ---
    my $this = shift;
    my $kiwi = $this -> {kiwi};
    my $confDir = $this -> {dataDir};
    my $cmdL = $this -> __getCommandLineObj();
    my $xml = $this -> __getXMLObj($confDir, $cmdL);
        $xml -> setBuildType('tbz');
        my $image = $this -> __getImageObj($xml, $cmdL);
    my $tmpDir = $this -> createTestTmpDir();
    $cmdL -> setImageTargetDir($tmpDir);
    my $bFact = KIWIImageBuildFactory -> new($xml, $cmdL, $image);
    $this -> assert_not_null($bFact);
    my $builder = $bFact -> getImageBuilder();
    my $msg = $kiwi -> getMessage();
    $this -> assert_str_equals('No messages set', $msg);
    my $msgT = $kiwi -> getMessageType();
    $this -> assert_str_equals('none', $msgT);
    my $state = $kiwi -> getState();
    $this -> assert_str_equals('No state set', $state);
    # Test this condition last to get potential error messages
    $this -> assert_str_equals(ref($builder), 'KIWITarArchiveBuilder');
    $this ->  removeTestTmpDir();
    return;
}

#==========================================
# Private helper methods
#------------------------------------------
#==========================================
# __getCommandLineObj
#------------------------------------------
sub __getCommandLineObj {
    # ...
    # Return an empty command line
    # ---
    my $cmdL = KIWICommandLine -> new();
    return $cmdL;
}

#==========================================
# __getImageObj
#------------------------------------------
sub __getImageObj {
        # ...
        # Return a basic KIWIImageObject
        # ---
        my $this = shift;
        my $xml  = shift;
        my $cmdL = shift;
        my $image = KIWIImage -> new($xml, '/tmp', '/tmp', undef, '/tmp', '/tmp',
                                                                 undef, $cmdL);
        return $image;
}

#==========================================
# __getXMLObj
#------------------------------------------
sub __getXMLObj {
    # ...
    # Create an XML object with the given config dir
    # ---
    my $this      = shift;
    my $configDir = shift;
    my $cmdL = shift;
    my $kiwi = $this->{kiwi};
    # TODO
    # Fix the creation of the XML object once the ctor arguments change
    my $xml = KIWIXML -> new(
        $configDir, undef, undef, $cmdL
    );
    if (! $xml) {
        my $errMsg = $kiwi -> getMessage();
        print "XML create msg: $errMsg\n";
        my $msg = 'Failed to create XML obj, most likely improper config '
        . 'path: '
        . $configDir;
        $this -> assert_equals(1, $msg);
    }
    return $xml;
}

1;
