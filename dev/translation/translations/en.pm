package Inprint::I18N::en;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use base 'Inprint::I18N';

use utf8;

our %Lexicon = (
    "About"                       => "",
    "About this software"         => "",
    "Access"                      => "",
    "Account removal"             => "",
    "Add"                         => "",
    "Add chain"                   => "",
    "Adjustment"                  => "",
    "Advertising"                 => "",
    "Alias"                       => "",
    "All"                         => "",
    "Archive"                     => "",
    "Are you want to logout?"     => "",
    "Branches"                    => "",
    "Briefcase"                   => "",
    "Calendar"                    => "",
    "Cancel"                      => "",
    "Capture"                     => "",
    "Card"                        => "",
    "Catalog"                     => "",
    "Catalog item creation"       => "",
    "Change"                      => "",
    "Change chain"                => "",
    "Change of access rights"     => "",
    "Change stage"                => "",
    "Close"                       => "",
    "Close this panel"            => "",
    "Closing date"                => "",
    "Color"                       => "",
    "Communication error"         => "",
    "Company news"                => "",
    "Composition"                 => "",
    "Copy"                        => "",
    "Copy from"                   => "",
    "Create"                      => "",
    "Create chain"                => "",
    "Create document"             => "",
    "Create stage"                => "",
    "Default destination"         => "",
    "Delete"                      => "",
    "Delete chain"                => "",
    "Description"                 => "",
    "Disable"                     => "",
    "Displaying documents {0} - {1} of {2}"=> "",
    "Document capture"            => "",
    "Document profile"            => "",
    "Document restoration"        => "",
    "Documents"                   => "",
    "Dumb window"                 => "",
    "Duplicate"                   => "",
    "Edit"                        => "",
    "Edit profile"                => "",
    "Edition"                     => "",
    "Edition addition"            => "",
    "Edition removal"             => "",
    "Editions"                    => "",
    "Employee"                    => "",
    "Employee information"        => "",
    "Employee profile"            => "",
    "Employee settings"           => "",
    "Employee setup"              => "",
    "Employeers list"             => "",
    "Employees"                   => "",
    "Employees browser"           => "",
    "Empoyees online"             => "",
    "Enable"                      => "",
    "Event"                       => "",
    "Event type"                  => "",
    "Exchange"                    => "",
    "Fascic;e"                    => "",
    "Fascicle"                    => "",
    "Filter"                      => "",
    "Find"                        => "",
    "Group"                       => "",
    "Group by"                    => "",
    "Group removal"               => "",
    "Group rules"                 => "",
    "Headline"                    => "",
    "Help"                        => "",
    "Help center"                 => "",
    "Holder"                      => "",
    "ID"                          => "",
    "Inprint"                     => "",
    "Irreversible removal"        => "",
    "Items"                       => "",
    "Label"                       => "",
    "Limit"                       => "",
    "Limitation..."               => "",
    "Loading"                     => "",
    "Loading..."                  => "",
    "Login"                       => "",
    "Logout"                      => "",
    "Logs"                        => "",
    "Manager"                     => "",
    "Members"                     => "",
    "Membership"                  => "",
    "Moving to the briefcase"     => "",
    "Moving to the recycle bin"   => "",
    "My alerts"                   => "",
    "Name"                        => "",
    "No chains to display"        => "",
    "No documents to display"     => "",
    "Not defined"                 => "",
    "Not implemented"             => "",
    "Opening date"                => "",
    "Organization"                => "",
    "Pages"                       => "",
    "Password"                    => "",
    "Path to image"               => "",
    "Percent"                     => "",
    "Photo"                       => "",
    "Plan"                        => "",
    "Planning"                    => "",
    "Please wait..."              => "",
    "Portal"                      => "",
    "Position"                    => "",
    "Principals list"             => "",
    "Probably someone has entered in Inprint with your login on other computer. <br/> push F5 what to pass to authorization page"=> "",
    "Profile"                     => "",
    "Profile of the employee"     => "",
    "Progress"                    => "",
    "Readiness"                   => "",
    "Record date"                 => "",
    "Recycle"                     => "",
    "Recycle Bin"                 => "",
    "Recycle bin"                 => "",
    "Refresh this panel"          => "",
    "Release addition"            => "",
    "Release change"              => "",
    "Reload"                      => "",
    "Remove"                      => "",
    "Restore"                     => "",
    "Review of access rights"     => "",
    "Rights"                      => "",
    "Role"                        => "",
    "Roles"                       => "",
    "Root node"                   => "",
    "Rubric"                      => "",
    "Rubrics"                     => "",
    "Rule"                        => "",
    "Rules"                       => "",
    "Save"                        => "",
    "Save recursive"              => "",
    "Select"                      => "",
    "Select employees"            => "",
    "Select..."                   => "",
    "Settings"                    => "",
    "Shortcut"                    => "",
    "Show archvies"               => "",
    "Suitable data is not found"  => "",
    "System Information"          => "",
    "System information"          => "",
    "System profile"              => "",
    "Termination of membership"   => "",
    "The rights"                  => "",
    "Title"                       => "",
    "To add a document"           => "",
    "Todo"                        => "",
    "Transfer"                    => "",
    "Transfer browser"            => "",
    "Transfer settings"           => "",
    "Unknown fascicle"            => "",
    "Unnamed window"              => "",
    "Update"                      => "",
    "User Information"            => "",
    "View"                        => "",
    "Warning"                     => "",
    "Weight"                      => "",
    "You can't cancel this action!"=> "",
    "You really want to do it?"   => "",
    "You really want to do this?" => "",
    "You really want to remove the selected accounts?"=> "",
    "You really want to stop membership in group for the selected accounts?"=> "",
    "You really wish to do this?" => "",
    "Your session is closed"      => "",
    "rubric"                      => "",
);

sub get {
    my $c = shift;
    my $key = shift;
    return $Lexicon{$key} || $key;
}

sub getAll {
    return \%Lexicon;
}

1;
