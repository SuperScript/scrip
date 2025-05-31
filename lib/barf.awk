#include "shout.awk"
function barf(msg) { shout("fatal: " msg); exit 111; }
