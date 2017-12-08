from fabric.api import sudo, run, task, get, put, prompt
import sys


def remote_ex():
    prompt('please type the command!')
    run(str(sys.stdin.readline()))
