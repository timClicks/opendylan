module:     access-path-implementation
synopsis:   Implementation of stop reasons
author:     Paul Howard
Copyright:    Original Code is Copyright (c) 1995-2004 Functional Objects, Inc.
              All rights reserved.
License:      See License.txt in this distribution for details.
Warranty:     Distributed WITHOUT WARRANTY OF ANY KIND

// Stop reason integer codes...(in no particular order)

define constant $timed-out                           = 0;
define constant $timed-out-handled                   = 32;
define constant $timed-out-unhandled                 = 33;
define constant $access-violation                    = 1;
define constant $array-bounds-exception              = 2;
define constant $illegal-instruction-exception       = 3;
define constant $privileged-instruction-exception    = 4;
define constant $denormal-exception                  = 5;
define constant $float-divide-by-zero-exception      = 6;
define constant $inexact-result-exception            = 7;
define constant $invalid-float-operation-exception   = 8;
define constant $float-overflow-exception            = 9;
define constant $float-underflow-exception           = 10;
define constant $float-stack-check-exception         = 11;
define constant $integer-divide-by-zero-exception    = 12;
define constant $noncontinuable-exception            = 13;
define constant $breakpoint-exception                = 14;
define constant $hard-coded-breakpoint-exception     = 15;
define constant $single-step-exception               = 16;
define constant $create-process                      = 17;
define constant $exit-process                        = 18;
define constant $create-thread                       = 19;
define constant $exit-thread                         = 20;
define constant $load-dll                            = 21;
define constant $unload-dll                          = 22;
// define constant $RIP                                 = 23;
define constant $output-debug-string                 = 24;
define constant $profiler                            = 25;
define constant $profiler-unhandled                  = 34;
define constant $unclassified                        = 26;
define constant $integer-overflow-exception          = 27;
define constant $stack-overflow-exception            = 28;
define constant $source-step-over                    = 29;
define constant $source-step-out                     = 30;
define constant $source-step-into                    = 31;

define constant $step-operation-step-out     = 7;
define constant $step-operation-step-over    = 8;
define constant $step-operation-step-into    = 9;


///// <STOP-REASON>
//    The most general reason why an application stops internally. This is
//    the root of a fairly large hierarchy.

define abstract sealed class <stop-reason> (<object>)
end class;


///// <INTERNAL-STOP-REASON>
//    Stop-reasons defined by the access path, representing debug events
//    within the application.

define abstract sealed class <internal-stop-reason> (<stop-reason>)

  constant slot stop-reason-process :: <remote-process>,
    required-init-keyword: process:;

  constant slot stop-reason-thread :: <remote-thread>,
    required-init-keyword: thread:;

end class;


///// <BASIC-STOP-REASON>
//    Stop reasons defined by the access path, representing system-level
//    debug events generated from within the application.

define abstract sealed class <basic-stop-reason> (<internal-stop-reason>)
end class;


///// <LANGUAGE-LEVEL-STOP-REASON>
//    Stop reasons NOT defined by the access path. These represent
//    stop-reasons generated by the application, but not at system level.

define abstract open class <language-level-stop-reason>
    (<internal-stop-reason>)
end class;


// The application can now timeout on an incoming debug event 
// (e.g. page faults), for which the debugger needs to pass back
// an unhandled exception; this stop-reason models those special
// circumstances

define abstract open class <unhandled-stop-reason> (<stop-reason>)
end class;


///// <EXTERNAL-STOP-REASON>
//    Stop reasons NOT defined by the access path. Left as an open class
//    for clients to expand upon.

define abstract open class <external-stop-reason> (<stop-reason>)
end class;


///// <PROFILER-STOP-REASON>
//    The stop reason generated by the profiler engine when its time
//    to gather statistical data from the stack.

define class <profiler-stop-reason> (<external-stop-reason>)
end class;

// Models profiler timeouts on incoming unhandled debug events

define class <profiler-unhandled-stop-reason>
    (<profiler-stop-reason>, <unhandled-stop-reason>)
end class;


define class <timeout-stop-reason> (<external-stop-reason>)
end class;

// Models timeouts on incoming handled & unhandled debug events

define class <timeout-handled-stop-reason> (<timeout-stop-reason>)
end class;

define class <timeout-unhandled-stop-reason>
    (<timeout-stop-reason>, <unhandled-stop-reason>)
end class;


define abstract class <process-stop-reason> (<basic-stop-reason>)
end class;

define class <create-process-stop-reason> (<process-stop-reason>)
  constant slot stop-reason-executable-component :: <remote-library>,
    required-init-keyword: executable:;
end class;

define class <exit-process-stop-reason> (<process-stop-reason>)
  constant slot stop-reason-process-exit-code :: <integer>,
    required-init-keyword: exit-code:;
end class;

define abstract class <thread-stop-reason> (<basic-stop-reason>)
end class;

define class <create-thread-stop-reason> (<thread-stop-reason>)
end class;

define class <exit-thread-stop-reason> (<thread-stop-reason>)
  constant slot stop-reason-thread-exit-code :: <integer>,
    required-init-keyword: exit-code:;
end class;

define abstract class <library-stop-reason> (<basic-stop-reason>)
  constant slot stop-reason-library :: <remote-library>,
    required-init-keyword: library:;
end class;

define class <load-library-stop-reason> (<library-stop-reason>)
end class;

define class <unload-library-stop-reason> (<library-stop-reason>)
end class;

define class <RIP-stop-reason> (<basic-stop-reason>)
  constant slot stop-reason-exit-code :: <integer>,
    required-init-keyword: exit-code:;
end class;

define class <output-debug-string-stop-reason> (<basic-stop-reason>)
  constant slot stop-reason-debug-string :: <string>,
    required-init-keyword: debug-string:;
end class;

define abstract class <debug-point-stop-reason> (<basic-stop-reason>)
  constant slot stop-reason-debug-point-address :: <remote-value>,
    required-init-keyword: address:;
end class;

define class <breakpoint-stop-reason> (<debug-point-stop-reason>)
end class;

define class <source-step-stop-reason> (<breakpoint-stop-reason>)
end class;

define class <source-step-out-stop-reason> (<source-step-stop-reason>)
end class;

define class <source-step-over-stop-reason> (<source-step-stop-reason>)
end class;

define class <source-step-into-stop-reason> (<source-step-stop-reason>)
end class;

define class <single-step-stop-reason> (<breakpoint-stop-reason>)
end class;

define class <watchpoint-stop-reason> (<debug-point-stop-reason>)
end class;

define class <read-watchpoint-stop-reason> (<watchpoint-stop-reason>)
end class;

define class <write-watchpoint-stop-reason> (<watchpoint-stop-reason>)
end class;

define class <execute-watchpoint-stop-reason> (<watchpoint-stop-reason>)
end class;

define abstract class <exception-stop-reason> (<basic-stop-reason>)

  constant slot stop-reason-exception-address :: <remote-value>,
    required-init-keyword: exception-address:;

  constant slot stop-reason-exception-first-chance? :: <boolean>,
    init-value: #f,
    init-keyword: first-chance?:;

end class;

define abstract class <invoke-debugger-stop-reason> (<exception-stop-reason>)
end class;

define class <system-initialized-stop-reason> (<invoke-debugger-stop-reason>)
end class;

define class <system-invoke-debugger-stop-reason>
                                              (<invoke-debugger-stop-reason>)
end class;

define abstract class <memory-exception-stop-reason> (<exception-stop-reason>)
end class;

define constant $access-violation-undecidable = 0;
define constant $access-violation-on-read = 1;
define constant $access-violation-on-write = 2;
define constant $access-violation-on-execute = 3;

define class <access-violation-stop-reason> (<memory-exception-stop-reason>)

  constant slot stop-reason-access-violation-address :: <remote-value>,
    required-init-keyword: violation-address:;

  constant slot stop-reason-access-violation-operation :: <integer>,
    required-init-keyword: violation-operation:;

end class;

define class <array-bounds-exception-stop-reason>
    (<memory-exception-stop-reason>)
end class;

define abstract class <instruction-exception-stop-reason> 
    (<exception-stop-reason>)
end class;

define class <illegal-instruction-exception-stop-reason>
    (<instruction-exception-stop-reason>)
end class;

define class <privileged-instruction-exception-stop-reason>
    (<instruction-exception-stop-reason>)
end class;

define abstract class <arithmetic-exception-stop-reason> 
    (<exception-stop-reason>)
end class;

define abstract class <float-exception-stop-reason> 
    (<arithmetic-exception-stop-reason>)
end class;

define class <denormal-exception-stop-reason> (<float-exception-stop-reason>)
end class;

define class <float-divide-by-zero-exception-stop-reason>
    (<float-exception-stop-reason>)
end class;

define class <inexact-result-exception-stop-reason>
    (<float-exception-stop-reason>)
end class;

define class <invalid-float-operation-exception-stop-reason>
    (<float-exception-stop-reason>)
end class;

define class <float-overflow-exception-stop-reason>
    (<float-exception-stop-reason>)
end class;

define class <float-underflow-exception-stop-reason>
    (<float-exception-stop-reason>)
end class;

define class <float-stack-check-exception-stop-reason>
    (<float-exception-stop-reason>)
end class;

define abstract class <integer-exception-stop-reason> 
    (<exception-stop-reason>)
end class;

define class <integer-divide-by-zero-exception-stop-reason>
    (<integer-exception-stop-reason>)
end class;

define class <integer-overflow-exception-stop-reason>
    (<integer-exception-stop-reason>)
end class;

define class <stack-overflow-exception-stop-reason>
    (<exception-stop-reason>)
end class;

define class <noncontinuable-exception-stop-reason> 
    (<exception-stop-reason>)
end class;

define class <unclassified-exception-stop-reason>
    (<exception-stop-reason>)
end class;


///// WAIT-FOR-STOP-REASON

define method wait-for-stop-reason 
    (ap :: <access-path>, #key timeout = #f, profile-interval = #f)
      => (maybe-sr :: false-or(<stop-reason>))

  let sr = #f;

  if (timeout)
    sr := wait-for-stop-reason-with-timeout (ap.connection, timeout,
                                             profile-at: profile-interval)
  else
    sr := wait-for-stop-reason-no-timeout (ap.connection,
                                           profile-at: profile-interval)
  end if;

  if (sr ~= $timed-out)
    set-application-state (ap, #"stopped");
    construct-stop-reason (ap, sr);
  else
     #f
  end if;
end method;


///// WAIT-FOR-STOP-REASON-WITH-TIMEOUT
//    Called if the timeout keyword is supplied.

define open generic wait-for-stop-reason-with-timeout 
    (conn :: <access-connection>, timeout :: <integer>,
     #key)
 => (code :: <integer>);


///// WAIT-FOR-STOP-REASON-NO-TIMEOUT
//    Called if no timeout keyword is supplied.

define open generic wait-for-stop-reason-no-timeout 
    (conn :: <access-connection>,
     #key) => (code :: <integer>);


///// GET-DEBUG-EVENT-PROCESS-EXIT-CODE
//    Given that the last received stop reason was an
//    <exit-process-stop-reason>, this returns the exit code.
       
define open generic get-debug-event-process-exit-code
    (conn :: <access-connection>) => (code :: <integer>);


///// GET-DEBUG-EVENT-THREAD-EXIT-CODE
//    Given that the last received stop reason was an
//    <exit-thread-stop-reason>, this returns the exit code.

define open generic get-debug-event-thread-exit-code
    (conn :: <access-connection>) => (code :: <integer>);


///// GET-DEBUG-EVENT-STRING-INFORMATION
//    Given that the last received stop reason was an
//    <output-debug-string-stop-reason>, grab the address
//    and length of the string from the debugger nub.

define open generic get-debug-event-string-information
    (conn :: <access-connection>)
 => (addr :: <remote-value>,
     sz :: <integer>,
     unicode? :: <boolean>);


///// GET-DEBUG-EVENT-LIBRARY
//    Given that the last received stop reason was one that has to
//    do with a remote-library, this returns a handle on the affected
//    library.

define open generic get-debug-event-library
    (conn :: <access-connection>) => (lib :: <NUBLIBRARY>);


///// GET-DEBUG-EVENT-THREAD
//    All stop reasons are associated with the thread that generated
//    them. This function returns a handle on that thread.

define open generic get-debug-event-thread 
    (conn :: <access-connection>)=> (thr :: <NUBTHREAD>);


///// GET-DEBUG-EVENT-PROCESS
//    This function is currently pointless, since there is only one
//    <remote-process>.

define open generic get-debug-event-process 
    (conn :: <access-connection>) => (proc :: <remote-process>);


///// GET-EXCEPTION-ADDRESS
//    Returns the address at which the last exception was encountered.
//    We only currently make use of this for finding out where a
//    breakpoint was hit. We could perhaps make more use of it...

define open generic get-exception-address (conn :: <access-connection>)
    => (ptr :: <remote-value>);


///// EXCEPTION-IS-FIRST-CHANCE?
//    Decides whether an exception is a first-chance exception

define open generic exception-is-first-chance? (conn :: <access-connection>)
    => (answer :: <boolean>);


///// GET-EXCEPTION-VIOLATION-ADDRESS
//    Returns the address that the application was trying to access when
//    an access violation occurred.

define open generic get-exception-violation-address 
  (conn :: <access-connection>)
    => (ptr :: <remote-value>);


///// GET-EXCEPTION-VIOLATION-OP
//    Returns a code for the operation that the application was trying
//    to perform when an access violation occurred.

define open generic get-exception-violation-op (conn :: <access-connection>)
    => (op :: <integer>);


///// FIRST-DEBUGGER-INVOCATION?
//    Is this the first time that the application has signalled a hard-coded
//    breakpoint?
//    If so, we will assume this breakpoint to be "special", and that it
//    is a signal that the application, and all of its shared libraries,
//    have loaded and performed their system-level initializations. On
//    Windows, this is true for free. Debugger nubs on other platforms,
//    however, might need to force the generation of this stop reason.

define open generic first-debugger-invocation?
    (conn :: <access-connection>) => (well? :: <boolean>);


///// CONSTRUCT-STOP-REASON
//    Given a low-level stop-reason code, this constructs a high-level
//    stop reason event object. (Returns #f if the code indicates a
//    timeout).

define method construct-stop-reason 
    (ap :: <access-path>, event-type :: <integer>,
     #key process, thread)
       => (maybe-sr :: false-or(<stop-reason>))

  let source-process :: <remote-process> =
    process | get-debug-event-process (ap.connection);
  let source-thread = 
    if (thread) thread
    else
      unless (profiler-event?(event-type))
	find-or-make-thread 
	  (ap, get-debug-event-thread (ap.connection))
      end unless;
    end if;

  let source-library = #f;
  let stop-reason = #f;

  if (source-thread)
    select (event-type)
      $exit-thread, $exit-process, $create-thread, $create-process => #f;
      otherwise =>
	update-thread-stack-size-on-connection(ap.connection, source-thread);
    end select;
  end if;

  select (event-type)

    $timed-out => 
      stop-reason := #f;

    $timed-out-handled => 
      stop-reason := make(<timeout-handled-stop-reason>);

    $timed-out-unhandled => 
      stop-reason := make(<timeout-unhandled-stop-reason>);

    $create-process =>
      source-library := find-or-make-library 
                          (ap, get-debug-event-library (ap.connection));
      stop-reason := make (<create-process-stop-reason>,
			   process: source-process,
			   thread: source-thread,
			   executable: source-library);
      register-access-path(ap);

    $create-thread =>
      stop-reason := make (<create-thread-stop-reason>,
                           process: source-process,
                           thread: source-thread);

    $exit-process =>
      stop-reason := make (<exit-process-stop-reason>,
                           process: source-process,
                           thread: source-thread,
                           exit-code:
                             get-debug-event-process-exit-code
                               (ap.connection));
      deregister-access-path(ap);

    $exit-thread =>
      stop-reason := make (<exit-thread-stop-reason>,
                           process: source-process,
                           thread: source-thread,
                           exit-code:
                             get-debug-event-thread-exit-code
                               (ap.connection));
      ap.threads := remove! (ap.threads, source-thread);
 
    $load-dll =>
      source-library :=
        find-or-make-library 
          (ap, get-debug-event-library (ap.connection));
      stop-reason := make (<load-library-stop-reason>,
                           process: source-process,
                           thread: source-thread,
                           library: source-library);

    $unload-dll =>
      source-library :=
        find-or-make-library 
          (ap, get-debug-event-library (ap.connection));
      stop-reason := make (<unload-library-stop-reason>,
                           process: source-process,
                           thread: source-thread,
                           library: source-library);
      ap.libraries := remove! (ap.libraries, source-library);

    $output-debug-string =>
      let (string-address, string-length, string-unicode?)
        = get-debug-event-string-information(ap.connection);
      let str = "";
      if (~string-unicode?)
        block ()
          str := read-byte-string (ap, string-address, string-length);
        exception (<remote-access-violation-error>)
          str := "<internal debugger error in reporting this message>"
        end block;
      end if;
      stop-reason := make (<output-debug-string-stop-reason>,
                           process: source-process,
                           thread: source-thread,
                           debug-string: str);

    $access-violation => 
      stop-reason := make (<access-violation-stop-reason>,
                           exception-address: 
                               get-exception-address(ap.connection),
                           first-chance?:
                               exception-is-first-chance?(ap.connection),
                           violation-address:
                               get-exception-violation-address(ap.connection),
                           violation-operation:
                               get-exception-violation-op(ap.connection),
                           process: source-process,
                           thread: source-thread);

    $array-bounds-exception =>
      stop-reason := make (<array-bounds-exception-stop-reason>,
                           exception-address: 
                               get-exception-address(ap.connection),
                           first-chance?:
                               exception-is-first-chance?(ap.connection),
                           process: source-process,
                           thread: source-thread);

    $illegal-instruction-exception =>
      stop-reason := make (<illegal-instruction-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);

    $privileged-instruction-exception =>
      stop-reason := make (<privileged-instruction-exception-stop-reason>,
                           exception-address: 
                               get-exception-address(ap.connection),
                           first-chance?:
                               exception-is-first-chance?(ap.connection),
                           process: source-process,
                           thread: source-thread);

    $denormal-exception =>
      stop-reason := make (<denormal-exception-stop-reason>,
                           exception-address: 
                               get-exception-address(ap.connection),
                           first-chance?:
                               exception-is-first-chance?(ap.connection),
                           process: source-process,
                           thread: source-thread);

    $float-divide-by-zero-exception =>
      stop-reason := make (<float-divide-by-zero-exception-stop-reason>,
                           exception-address: 
                               get-exception-address(ap.connection),
                           first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);

    $inexact-result-exception =>
      stop-reason := make (<inexact-result-exception-stop-reason>,
                           exception-address: 
                               get-exception-address(ap.connection),
                           first-chance?:
                               exception-is-first-chance?(ap.connection),
                           process: source-process,
                           thread: source-thread);
 
    $invalid-float-operation-exception =>
      stop-reason := make (<invalid-float-operation-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);

    $float-overflow-exception =>
      stop-reason := make (<float-overflow-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);

    $float-underflow-exception =>
      stop-reason := make (<float-underflow-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);
  
    $float-stack-check-exception =>
      stop-reason := make (<float-stack-check-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);
 
    $integer-divide-by-zero-exception =>
      stop-reason := make (<integer-divide-by-zero-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);

    $noncontinuable-exception =>
      stop-reason := make (<noncontinuable-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);

    $integer-overflow-exception =>
      stop-reason := make (<integer-overflow-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);

    $stack-overflow-exception =>
      stop-reason := make (<stack-overflow-exception-stop-reason>,
                            exception-address: 
                               get-exception-address(ap.connection),
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            process: source-process,
                            thread: source-thread);

    $breakpoint-exception =>
      stop-reason := make (<breakpoint-stop-reason>,
                            process: source-process,
                            thread: source-thread,
                            address: get-exception-address (ap.connection));

    $source-step-out =>
      stop-reason := make (<source-step-out-stop-reason>,
                            process: source-process,
                            thread: source-thread,
                            address: get-exception-address (ap.connection));

    $source-step-into =>
      stop-reason := make (<source-step-into-stop-reason>,
                            process: source-process,
                            thread: source-thread,
                            address: get-exception-address (ap.connection));

    $source-step-over =>
      stop-reason := make (<source-step-over-stop-reason>,
                            process: source-process,
                            thread: source-thread,
                            address: get-exception-address (ap.connection));

    $hard-coded-breakpoint-exception =>
      if (first-debugger-invocation?(ap.connection))
        stop-reason := make (<system-initialized-stop-reason>,
                              exception-address: 
                                 get-exception-address(ap.connection),
                              first-chance?:
                                 exception-is-first-chance?(ap.connection),
                              process: source-process,
                              thread: source-thread);
      else
        stop-reason := make (<system-invoke-debugger-stop-reason>,
                              exception-address: 
                                 get-exception-address(ap.connection),
                              first-chance?:
                                 exception-is-first-chance?(ap.connection),
                              process: source-process,
                              thread: source-thread);
      end if;

    $single-step-exception =>
      stop-reason := make (<single-step-stop-reason>,
                            process: source-process,
                            thread: source-thread,
                            address: get-exception-address (ap.connection));

    $profiler =>
      stop-reason := make (<profiler-stop-reason>);

    $profiler-unhandled =>
      stop-reason := make (<profiler-unhandled-stop-reason>);

    otherwise =>
      stop-reason := make (<unclassified-exception-stop-reason>,
                            process: source-process,
                            thread: source-thread,
                            first-chance?:
                               exception-is-first-chance?(ap.connection),
                            exception-address: 
                                 get-exception-address (ap.connection));

  end select;
stop-reason;
end method;

define method profiler-event?
    (event :: <integer>) => (profiling? :: <boolean>)
  select (event)
    $profiler, $profiler-unhandled => #t;
    otherwise => #f;
  end;
end method;

define constant $exception-subset =
  vector (<access-violation-stop-reason>,
          <array-bounds-exception-stop-reason>,
          <illegal-instruction-exception-stop-reason>,
          <privileged-instruction-exception-stop-reason>,
          <denormal-exception-stop-reason>,
          <float-divide-by-zero-exception-stop-reason>,
          <inexact-result-exception-stop-reason>,
          <invalid-float-operation-exception-stop-reason>,
          <float-overflow-exception-stop-reason>,
          <float-underflow-exception-stop-reason>,
          <float-stack-check-exception-stop-reason>,
          <integer-divide-by-zero-exception-stop-reason>,
          <integer-overflow-exception-stop-reason>,
          <stack-overflow-exception-stop-reason>,
          <unclassified-exception-stop-reason>,
          <noncontinuable-exception-stop-reason>);


///// RECEIVABLE-FIRST-CHANCE-EXCEPTIONS
//    Returns the set of exception classes that the debugger is capable of
//    receiving and processing at first-chance.

define method receivable-first-chance-exceptions
  (ap :: <access-path>) => (seq :: <sequence>)

  if (ap.cached-receivable-first-chance-exceptions?)
    ap.cached-exception-set
  else
    let exceptions = make (<stretchy-vector>, size: 0);
    for (exception-class in $exception-subset)
      let (name, code)
        = exception-information (exception-class);
      if (connection-can-receive-first-chance (ap.connection, code))
        exceptions := add!(exceptions, exception-class);
      end if
    end for;
    ap.cached-receivable-first-chance-exceptions? := #t;
    ap.cached-exception-set := exceptions;
    exceptions;
  end if;
end method;


///// CONNECTION-CAN-RECEIVE-FIRST-CHANCE
//    Calls the nub to determine whether an exception is first-chance
//    receivable.

define open generic connection-can-receive-first-chance
   (conn :: <access-connection>, code :: <integer>)
     => (yes-or-no :: <boolean>);


///// RECEIVING-FIRST-CHANCE?
//    Is the given exception class currently being first-chance processed
//    at the access-path level?

define method receiving-first-chance?
    (ap :: <access-path>, etype :: <class>) => (yes-or-no :: <boolean>)

  if (member?(etype, receivable-first-chance-exceptions(ap)))
    if (member?(etype, ap.first-chance-exception-set))
      #t
    else
      #f
    end if
  else
    #f
  end if
end method;


///// EXCEPTION-INFORMATION
//    Returns the integer code for the stop-reason class, along with its name.

define method exception-information 
    (exception-class == <access-violation-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Access Violation", $access-violation)
end method;

define method exception-information 
    (exception-class == <unclassified-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Unclassified Exception", $unclassified)
end method;

define method exception-information 
    (exception-class == <array-bounds-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Array Bounds Exceeded", $array-bounds-exception)
end method;

define method exception-information 
    (exception-class == <illegal-instruction-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Illegal Instruction", $illegal-instruction-exception)
end method;

define method exception-information 
    (exception-class == <privileged-instruction-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Privileged Instruction", $privileged-instruction-exception)
end method;

define method exception-information 
    (exception-class == <integer-overflow-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Integer Overflow", $integer-overflow-exception)
end method;

define method exception-information 
    (exception-class == <stack-overflow-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Stack Overflow", $stack-overflow-exception)
end method;

define method exception-information 
    (exception-class == <denormal-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Float Denormal", $denormal-exception)
end method;

define method exception-information 
    (exception-class == <float-divide-by-zero-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Float Division By Zero", $float-divide-by-zero-exception)
end method;

define method exception-information 
    (exception-class == <inexact-result-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Inexact Float Result", $inexact-result-exception)
end method;

define method exception-information 
    (exception-class == <invalid-float-operation-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Invalid Float Operation", $invalid-float-operation-exception)
end method;

define method exception-information 
    (exception-class == <float-overflow-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Floating Point Overflow", $float-overflow-exception)
end method;

define method exception-information 
    (exception-class == <float-underflow-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Floating Point Underflow", $float-underflow-exception)
end method;

define method exception-information 
    (exception-class == <float-stack-check-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Floating Point Stack Error", $float-stack-check-exception)
end method;

define method exception-information 
    (exception-class == <integer-divide-by-zero-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Integer Division By Zero", $integer-divide-by-zero-exception)
end method;

define method exception-information 
    (exception-class == <noncontinuable-exception-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Noncontinuable Exception", $noncontinuable-exception)
end method;

define method exception-information 
    (exception-class == <breakpoint-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Breakpoint", $breakpoint-exception)
end method;

define method exception-information 
    (exception-class == <invoke-debugger-stop-reason>)
      => (name :: <string>, code :: <integer>)
  values ("Hard Coded Breakpoint", $hard-coded-breakpoint-exception)
end method;


///// EXCEPTION-NAME
//    Returns printable text for the exception class.

define method exception-name
  (ap :: <access-path>, ex :: <class>)
    => (name :: <string>)
  let (name, code)
    = exception-information(ex);
  name;
end method;


///// RECEIVING-FIRST-CHANCE?-SETTER
//    Filters (or unfilters) first-chance occurrences of the given exception
//    type.

define method receiving-first-chance?-setter
    (set == #t, ap :: <access-path>, etype :: <class>) => (b :: <boolean>)
  if (member?(etype, receivable-first-chance-exceptions(ap)))
    unless (member?(etype, ap.first-chance-exception-set))
      let (name, code)
        = exception-information(etype);
      ap.first-chance-exception-set := 
         add!(ap.first-chance-exception-set, etype);
      connection-set-first-chance(ap.connection, code);
    end unless;
  end if;
  #t;
end method;

define open generic connection-set-first-chance
   (conn :: <access-connection>, code :: <integer>) => ();

define method receiving-first-chance?-setter
    (set == #f, ap :: <access-path>, etype :: <class>) => (b :: <boolean>)
  if (member?(etype, receivable-first-chance-exceptions(ap)))
    if (member?(etype, ap.first-chance-exception-set))
      let (name, code)
        = exception-information(etype);
      ap.first-chance-exception-set :=
         remove!(ap.first-chance-exception-set, etype);
      connection-unset-first-chance(ap.connection, code);
    end if;
  end if;
  #f;
end method;

define open generic connection-unset-first-chance
   (conn :: <access-connection>, code :: <integer>) => ();


///// FIRST-CHANCE-EXCEPTION?
//    Is a thread stopped at a first-chance exception or not?

define method first-chance-exception?
    (app :: <access-path>, thread :: <remote-thread>) => (b :: <boolean>)
  connection-thread-stopped-at-first-chance?(app.connection, thread);
end method;

define open generic connection-thread-stopped-at-first-chance?
    (conn :: <access-connection>, thread :: <remote-thread>)
      => (b :: <boolean>);

