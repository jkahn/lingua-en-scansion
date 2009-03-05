use inc::Module::Install;

name           'Lingua-EN-Scansion';
all_from       'lib/Lingua/EN/Scansion.pm';

requires 'Lingua::EN::Phoneme';
requires 'Text::Hyphen';
requires 'List::Util';

WriteAll;
