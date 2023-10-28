-module(exer6).
-compile(export_all).

init_chat() ->
    Node2 = lists:nth(1,nodes()),
    io:format(Node2),
    Name1 = io:get_line('Enter your name: '),
    register (receive1, spawn(exer6,receiveM,[])),
    getMessage(1,string:trim(Name1),Node2).

init_chat2(Node1) ->
    {getNode1, Node1} ! node(),
    Name2 = io:get_line('Enter your name: '),
    register (receive2, spawn(exer6,receiveM,[])),
    getMessage(string:trim(Name2),Node1).

receiveM() ->
    receive
        {Name, "bye"} ->
            io:format(Name ++ " disconnected.~n");
        {Name, Message} ->
            io:format("~n" ++ Name ++ " : " ++ Message ++ "~n"),
            receiveM()
    end.

getMessage(Name, Node) ->
    Message = io:get_line(": "),
    io:format(Name ++ " : " ++ Message),
    {receive1, Node} ! {Name, string:trim(Message)},
    case string:trim(Message) of
        "bye" -> 
            io:format("You disconnected.~n");
        _ ->
            getMessage(Name, Node)
    end.
getMessage(1,Name, Node) ->
    Message = io:get_line(": "),
    io:format(Name ++ " : " ++ Message),
    {receive2, Node} ! {Name, string:trim(Message)},
    case string:trim(Message) of
        "bye" -> 
            io:format("You disconnected.~n");
        _ ->
            getMessage(1,Name, Node)
    end.