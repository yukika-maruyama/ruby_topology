Feature: Detect network topology

  In order to detect network topology
  As a Trema user
  I want to run topology-controller.rb

  Background:
    Given I cd to "../.."

  Scenario: Detect switch <-> switch link
    When I run `trema run topology-controller.rb -c network.conf` interactively
     And I wait for output to contain "topology updated"
     And I run `trema killall`
    Then the output should contain:
    """
    0x1 (port 1) <-> 0x3 (port 1)
    0x1 (port 2) <-> 0x2 (port 2)
    0x2 (port 1) <-> 0x3 (port 2)
    0x2 (port 2) <-> 0x1 (port 2)
    0x3 (port 1) <-> 0x1 (port 1)
    0x3 (port 2) <-> 0x2 (port 1)
    """

  Scenario: Delete a switch then topology updated
    Given I run `trema run topology-controller.rb -c network.conf` interactively
    And I wait for output to contain "topology updated"
    When I run `trema kill 0x3`
    And I wait for output to contain "Switch 0x3 deleted"
    And I run `sleep 5`
    And I run `trema killall`
    Then the output should contain:
    """
    topology updated
    0x1 (port 2) <-> 0x2 (port 2)
    0x2 (port 2) <-> 0x1 (port 2)
    topology updated
    """