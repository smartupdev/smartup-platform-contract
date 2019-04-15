## SmartUpIdeaToken 接口说明

#### 转账

````sol
function transfer(address _to, uint256 _value) public
参数说明：
address _to  转账到的地址
uint256 _value 转账的金额大小

事件：
Transfer(_from, _to, _value)
````

#### 从账户A转到账户B

````
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
参数说明：
address _from 账户A
address _to  账户B
uint256 _value 金额大小

返回值：
bool success
true 成功
false  失败
事件：
Transfer(_from, _to, _value)
````

#### 允许账户A转走我的币

```
function approve(address _spender, uint256 _value) public returns (bool success)
参数说明：
address _spender  账户A
uint256 _value    允许转走的金额

返回值： 
bool success
true 成功
false 失败
```

#### 允许账户A转走我的币并进行接下来的操作

````
function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success)
参数说明：
address _spender  账户A
uint256 _value 允许转走金额
bytes memory _extraData  接下来操作需要的参数或者其他；

返回值：
bool success
true 成功
false  失败
````

#### 销毁代币

````
function burn(uint256 _value) public returns (bool success)
参数说明：
uint256 _value  要销毁的代币数目

返回值：
bool success
true   成功
false  失败

事件：
Burn(msg.sender, _value)
````

#### 从账户A销毁代币

````
function burnFrom(address _from, uint256 _value) public returns (bool success)
参数说明：
address _from  账户A
uint256 _value 销毁代币数目

返回值：
bool success
true 成功
false 失败

事件：
Burn(_from, _value)
````

