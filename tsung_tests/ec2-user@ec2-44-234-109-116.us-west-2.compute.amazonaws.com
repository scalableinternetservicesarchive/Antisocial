<?xml version="1.0"?>
<!DOCTYPE tsung SYSTEM "/usr/local/share/tsung/tsung-1.0.dtd" [] >
<tsung loglevel="notice">
  <clients>
    <client host="localhost" maxusers="20000" use_controller_vm="true" />
  </clients>

  <servers>
    <server host="avani-micro-micro.eba-fz2dfqnp.us-west-2.elasticbeanstalk.com" port="80" type="tcp"></server>
  </servers>

  <load>
    <arrivalphase phase="1" duration="10" unit="second">
      <users arrivalrate="2" unit="second"></users>
    </arrivalphase>
    <arrivalphase phase="2" duration="10" unit="second">
      <users arrivalrate="4" unit="second"></users>
    </arrivalphase>
    <arrivalphase phase="3" duration="10" unit="second">
      <users arrivalrate="8" unit="second"></users>
    </arrivalphase>
    <arrivalphase phase="4" duration="10" unit="second">
      <users arrivalrate="16" unit="second"></users>
    </arrivalphase>
    <arrivalphase phase="5" duration="10" unit="second">
      <users arrivalrate="32" unit="second"></users>
    </arrivalphase>
    <!-- <arrivalphase phase="6" duration="10" unit="second">
      <users arrivalrate="64" unit="second"></users>
    </arrivalphase>
    <arrivalphase phase="7" duration="10" unit="second">
      <users arrivalrate="80" unit="second"></users>
    </arrivalphase>
    <arrivalphase phase="8" duration="10" unit="second">
      <users arrivalrate="256" unit="second"></users>
    </arrivalphase>
    <arrivalphase phase="9" duration="10" unit="second">
      <users arrivalrate="512" unit="second"></users>
    </arrivalphase>
    <arrivalphase phase="10" duration="10" unit="second">
      <users arrivalrate="1024" unit="second"></users>
    </arrivalphase> -->
  </load>

  <options>
    <!-- Set connection timeout to 2 seconds -->
    <option name="global_ack_timeout" value="2000"></option>
  </options>

  <sessions>

    <!-- WORKFLOW 1 -->
    <!-- ############################################################################################## -->
    <session name="user logs in and views user list" probability="20" type="ts_http">

      <!-- LOGIN -->
      <request>
        <dyn_variable name="authenticity_token" ></dyn_variable>
        <http url='/d/users/sign_in/' version='1.1' method='GET'></http>
      </request>

      <!-- wait for up to 2 seconds, user is typing names -->
      <thinktime value="2" random="true"></thinktime>

      <!-- create a random number to make a unique first name -->
      <setdynvars sourcetype="random_number" start="1" end="100">
        <var name="random_num" />
      </setdynvars>

      <setdynvars code='fun({Pid,DynVars})->{ok,Val}=ts_dynvars:lookup(authenticity_token,DynVars),re:replace(Val,"[+]","%2B",[global,{return,list}]) end.' sourcetype="eval">
        <var name="encoded_authenticity_token" />
      </setdynvars>

      <!-- user log in -->
      <if var="encoded_authenticity_token" neq="">
        <request subst="true">
          <http
                  url='/d/users/sign_in/'
                  version='1.1'
                  method='POST'
                  content_type="application/x-www-form-urlencoded"
                  contents='authenticity_token=%%_encoded_authenticity_token%%&amp;user%5Bemail%5D=user_%%_random_num%%%40gmail.com&amp;user%5Bpassword%5D=Password1234&amp;user%5Bremember_me%5D=0&amp;commit=Log+in'>
          </http>
        </request>
      </if>


      <!--get users, i.e. go to users page  -->
      <request>
        <!-- <dyn_variable name="users_authenticity_token" xpath="//head/meta[@name='csrf-token']/@content"></dyn_variable>
        <dyn_variable name="friend_num_url" xpath="/html/body//div[@class='card-body']/a/@href"></dyn_variable> -->
        <http url="/users/" version="1.1" method="GET"></http>
      </request>


    </session>

    <!-- WORKFLOW 2 -->
    <!-- ############################################################################################## -->
    <session name="user logs in and views posts" type="ts_http" probability="50">

      <!--  1) User logs in -->
      <!-- LOGIN -->
      <request>
        <dyn_variable name="authenticity_token" ></dyn_variable>
        <http url='/d/users/sign_in/' version='1.1' method='GET'></http>
      </request>

      <!-- wait for up to 2 seconds, user is typing names -->
      <thinktime value="2" random="true"></thinktime>

      <!-- create a random number to make a unique first name -->
      <setdynvars sourcetype="random_number" start="1" end="100">
        <var name="random_num" />
      </setdynvars>

      <setdynvars code='fun({Pid,DynVars})->{ok,Val}=ts_dynvars:lookup(authenticity_token,DynVars),re:replace(Val,"[+]","%2B",[global,{return,list}]) end.' sourcetype="eval">
        <var name="encoded_authenticity_token" />
      </setdynvars>


      <!-- user log in -->
      <if var="encoded_authenticity_token" neq="">
        <request subst="true">
          <http
                  url='/d/users/sign_in/'
                  version='1.1'
                  method='POST'
                  content_type="application/x-www-form-urlencoded"
                  contents='authenticity_token=%%_encoded_authenticity_token%%&amp;user%5Bemail%5D=user_%%_random_num%%%40gmail.com&amp;user%5Bpassword%5D=Password1234&amp;user%5Bremember_me%5D=0&amp;commit=Log+in'>
          </http>
        </request>
      </if>

      <!--      2) User looks at all posts-->
      <request><http method="GET" url="/posts/"></http></request>

    </session>


    <!-- WORKFLOW 3 -->
    <!-- ############################################################################################## -->
    <session name="user logs in, creates post, deletes post and logs out" type="ts_http" probability="30">

    <!--  1) User logs in -->
    <!-- LOGIN -->
    <request>
        <dyn_variable name="authenticity_token" ></dyn_variable>
        <http url='/d/users/sign_in/' version='1.1' method='GET'></http>
    </request>

    <!-- wait for up to 2 seconds, user is typing names -->
    <thinktime value="2" random="true"></thinktime>

    <!-- create a random number to make a unique first name -->
    <setdynvars sourcetype="random_number" start="1" end="100">
        <var name="random_num" />
     </setdynvars>

    <setdynvars code='fun({Pid,DynVars})->{ok,Val}=ts_dynvars:lookup(authenticity_token,DynVars),re:replace(Val,"[+]","%2B",[global,{return,list}]) end.' sourcetype="eval">
      <var name="encoded_authenticity_token" />
    </setdynvars>


    <!-- user log in -->
    <if var="encoded_authenticity_token" neq="">
    <request subst="true">
        <http
        url='/d/users/sign_in/'
        version='1.1'
        method='POST'
        content_type="application/x-www-form-urlencoded"
        contents='authenticity_token=%%_encoded_authenticity_token%%&amp;user%5Bemail%5D=user_%%_random_num%%%40gmail.com&amp;user%5Bpassword%5D=Password1234&amp;user%5Bremember_me%5D=0&amp;commit=Log+in'>
        </http>
    </request>
    </if>

      <!--      2) User looks at all posts-->
    <request><http method="GET" url="/posts/"></http></request>


    <!--      3) User create a new post-->
    <request>
        <dyn_variable name="newpost_authenticity_token" xpath="//head/meta[@name='csrf-token']/@content"></dyn_variable>
        <http url="/posts/new/" version="1.1" method="GET"></http>
    </request>

    <setdynvars code='fun({Pid,DynVars})->{ok,Val}=ts_dynvars:lookup(newpost_authenticity_token,DynVars),re:replace(Val,"[+]","%2B",[global,{return,list}]) end.' sourcetype="eval">
      <var name="encoded_newpost_authenticity_token" />
    </setdynvars>

    <thinktime value="2" random="true"></thinktime>

    <if var="encoded_newpost_authenticity_token" neq="">
    <request subst="true">
        <http url="/posts/" method="POST" version="1.1"
            content_type="application/x-www-form-urlencoded"
            contents="authenticity_token=%%_encoded_newpost_authenticity_token%%&amp;post%5Btitle%5D=AAAaaaaaa&amp;post%5Btext%5D=BBBBaaaa&amp;commit=Create+Post"/>
    </request>
    </if>

      <!--      4) User goes back to list of posts--> <!--Delete posts -->


    <request>
        <dyn_variable name="delete_post_authenticity_token" xpath="//head/meta[@name='csrf-token']/@content"></dyn_variable>
        <dyn_variable name="delete_post_url" xpath='/html/body//div[@class="card-body"]/p/a[@data-method="delete"]/@href'></dyn_variable>
        <http url="/posts/" version="1.1" method="GET"></http>
    </request>

    <setdynvars code='fun({Pid,DynVars})->{ok,Val}=ts_dynvars:lookup(delete_post_authenticity_token,DynVars),re:replace(Val,"[+]","%2B",[global,{return,list}]) end.' sourcetype="eval">
      <var name="encoded_delete_post_authenticity_token" />
    </setdynvars>

    <setdynvars sourcetype="eval"
        code='fun({Pid,DynVars})->
        {ok,Val}=ts_dynvars:lookup(delete_post_url,DynVars),
        lists:nth(1,Val) end.' >
        <var name="last_delete_post_url" />
    </setdynvars>



    <if var="encoded_delete_post_authenticity_token" neq="">
      <request subst="true">
      <http url="/%%_last_delete_post_url%%/" method="POST" version="1.1"
              content_type="application/x-www-form-urlencoded"
              contents="_method=delete&amp;authenticity_token=%%_encoded_delete_post_authenticity_token%%"/>
      </request>
    </if>

    <!--LOGOUT-->
    <request>
        <dyn_variable name="users_profile_authenticity_token_logout" xpath="//head/meta[@name='csrf-token']/@content"></dyn_variable>
        <http url='/users/profile' version='1.1' method='GET'></http>
    </request>

    <setdynvars code='fun({Pid,DynVars})->{ok,Val}=ts_dynvars:lookup(users_profile_authenticity_token_logout,DynVars),re:replace(Val,"[+]","%2B",[global,{return,list}]) end.' sourcetype="eval">
      <var name="encoded_users_profile_authenticity_token_logout" />
    </setdynvars>

    <if var="encoded_users_profile_authenticity_token_logout" neq="">
      <request subst="true">
          <http url='/d/users/sign_out'
          version='1.1'
          method='POST'
          content_type="application/x-www-form-urlencoded"
          contents='_method=delete&amp;authenticity_token=%%_encoded_users_profile_authenticity_token_logout%%'>
          </http>
      </request>
    </if>

    </session>
  </sessions>
</tsung>
