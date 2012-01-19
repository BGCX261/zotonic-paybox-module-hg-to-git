%% @author Michael Connors <michael@bring42.net>
%% @copyright 2012 Michael Connors
%% @date 2012-01-19
%% @doc Webmachine-based PayBox callback listener.
%% @end

%% Copyright 2012 Michael Connors
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%% 
%%     http://www.apache.org/licenses/LICENSE-2.0
%% 
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(resource_paybox_callback).
-author("Michael Connors <michael@bring42.net>").
-export([init/1]).

-export([
         init/1,
         content_types_provided/2,
         resource_exists/2,
         allowed_methods/2,
         process_post/2
        ]).

-include_lib("webmachine_resource.hrl").
-include_lib("zotonic.hrl").

init([]) ->
    {ok, []}.

resource_exists(ReqData, _Context) ->
    Context  = z_context:new(ReqData, ?MODULE),
    Context1 = z_context:ensure_qs(Context),
    {true, ReqData, Context1}.

content_types_provided(ReqData, Context) ->
    {[{"text/html", response}], ReqData, Context}.

allowed_methods(ReqData, Context) ->
    {['POST', 'GET'], ReqData, Context}.

process_post(_ReqData, Context) ->
    Error = z_context:get_q("error", Context), % E=The Error Code of teh transaction
    Amount = z_context:get_q("amount", Context), %M=Value of Order
    OrderReference = z_context:get_q("reference", Context), % R=Order Reference
    Transaction = z_context:get_q("transaction", Context), %T=Transaction identifier
    Status = z_context:get_q("status", Context), %% O=Status - possible values: Y=success N=Failed A=Attempts processing performed
    ?WM_REPLY(true, Context).

