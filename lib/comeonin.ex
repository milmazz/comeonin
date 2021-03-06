defmodule Comeonin do
  @moduledoc """
  Comeonin is a password hashing library that aims to make the
  secure validation of passwords as straightforward as possible.

  It also provides extensive documentation to help
  developers keep their apps secure.

  Comeonin supports bcrypt and pbkdf2_sha512.

  ## Use

  Most users will just need to use the `hashpwsalt`, `checkpw` and `dummy_checkpw`
  functions, using either the `Comeonin.Bcrypt` or `Comeonin.Pbkdf2` module.
  Naming conventions are the same for each algorithm.

  Import, or alias, the algorithm you want to use -- either `Comeonin.Bcrypt`
  or `Comeonin.Pbkdf2`.

  To hash a password with the default options:

    hash = hashpwsalt("difficult2guess")

  To check a password against the stored hash, use the `checkpw`
  function. This takes two arguments: the plaintext password and
  the stored hash.

  There is also a `dummy_checkpw` function, which takes no arguments
  and is to be used when the username cannot be found. It performs a hash,
  but then returns false. This can be used to make user enumeration more
  difficult. If an attacker already knows, or can guess, the username,
  this function will not be of any use, and so if you are going to use
  this function, it should be used with a policy of creating usernames
  that are not made public and are difficult to guess.

  See each module's documentation for more information about
  all the available options.

  ## Choosing an algorithm

  Bcrypt and pbkdf2_sha512 are both highly secure key derivation functions.
  They have no known vulnerabilities and their algorithms have been used
  and widely reviewed for at least 10 years. They are also designed
  to be `future-adaptable` (see the section below about speed / complexity
  for more details), and so we do not recommend one over the other.

  However, if your application needs to use a hashing function that has been
  recommended by a recognized standards body, then you will need to
  use pbkdf2_sha512, which has been recommended by NIST.

  ## Adjusting the speed / complexity of bcrypt and pbkdf2

  It is possible to adjust the speed / complexity of bcrypt and pbkdf2 by
  changing the number of rounds (the number of calculations) used. In most
  cases, you will not need to change the default number of rounds, but
  increasing the number of rounds can be useful because it limits the
  number of attempts an attacker can make within a certain time frame.
  It is not recommended to set the number of rounds lower than the
  defaults.

  To help you see how much time the hashing function takes with different
  numbers of rounds, this module provides convenience timing functions
  for bcrypt and pbkdf2.

  ## Further information

  Visit our [wiki](https://github.com/elixircnx/comeonin/wiki)
  for links to further information about these and related issues.

  """

  @doc """
  A function to help the developer decide how many log rounds to use
  when using bcrypt.

  The number of log rounds can be increased to make the bcrypt hashing
  function more complex, and slower. The minimum number is 4 and the maximum is 31.
  The default is 12, but, depending on the nature of your application and
  the hardware being used, you might want to increase this.

  The `bcrypt_log_rounds` value can be set in the config file. See the
  documentation for `Comeonin.Config` for more details.
  """
  def time_bcrypt(log_rounds \\ 12) do
    salt = Comeonin.Bcrypt.gen_salt(log_rounds)
    {time, _} = :timer.tc(Comeonin.Bcrypt, :hashpass, ["password", salt])
    Mix.shell.info "Log rounds: #{log_rounds}, Time: #{div(time, 1000)} ms"
  end

  @doc """
  A function to help the developer decide how many rounds to use
  when using pbkdf2.

  The number of rounds can be increased to make the pbkdf2 hashing function slower.
  The maximum number of rounds is 4294967295. The default is 160_000, but,
  depending on the nature of your application and the hardware being used,
  you might want to increase this.

  The `pbkdf2_rounds` value can be set in the config file. See the
  documentation for `Comeonin.Config` for more details.
  """
  def time_pbkdf2(rounds \\ 160_000) do
    salt = Comeonin.Pbkdf2.gen_salt
    {time, _} = :timer.tc(Comeonin.Pbkdf2, :hashpass, ["password", salt, rounds])
    Mix.shell.info "Rounds: #{rounds}, Time: #{div(time, 1000)} ms"
  end
end
