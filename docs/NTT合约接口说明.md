## NTT 合约接口说明

#### 关于NTT

````
1.NTT为smartUp平台的信用分合约；
2.所有账户默认初始值为100；
3.Grader有设置用户信用值的权限；
4.owner可设置或者取消Grader；
5.owner可以更换
````

#### 申请新的Owner更换请求

````
function initiateOwnershipTransfer(address newOwner) external onlyOwner 
参数说明：
address newOwner 要更换新的owner地址
````

####  取消申请的Owner更换请求

```
function cancelOwnershipTransfer() external onlyOwner
```

#### 接受成为新的Owner

```
function confirmOwnershipTransfer() external
```

#### 重置Owner为address（0）

````
function renounceOwnership() public onlyOwner
事件1：
OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
参数说明：
address indexed previousOwner  之前的owner
address indexed newOwner    现在的owner
````

#### 查看当前Owner

```
function owner() public view returns (address)
返回值：
address  当前owenr地址
```

#### 添加Grader

```
function addGrader(address grader) external onlyOwner
参数说明：
address grader 新添加的Grader地址

事件：
AddGrader(address _newGrader)
参数说明：
address _newGrader   添加的grader的地址
```

#### 移除Grader

```
function removeGrader(address grader) external onlyOwner
参数说明：
address  grader 移除的地址

事件：
RemoveGrader(address _removeGrader);
参数说明：
address _removeGrader  移除的garder地址
```

#### 查看信用分

```
function checkCredit(address user) public view returns (uint256)
参数说明：
address user 所查看的地址

返回值：
uint256  信用分数
```

#### 提升信用分

```
function raiseCredit(address user, uint256 score) external whenMigrationUnstarted onlyGrader
参数说明：
address user 需要提升的地址
uint256 score 需要增加的分数

事件：
RaiseCredit(address _raiseAddress, uint256 _score);
参数说明：
address _raiseAddress   需要提升信用分的地址
uint256 _score     需要提升的分数
```

#### 减少信用分

```
function lowerCredit(address user, uint256 score) external whenMigrationUnstarted onlyGrader
参数说明：
address user  需要减少信用分的地址
uint256 score 需要减少的分数

事件：
LowerCredit(address _lowerAddress, uint256 _score);
参数说明：
address _lowerAddress  需要减少信用分的地址
uint256 _score    需要减少的分数
```

#### owner 调整默认的信用分值

````
function adjustDefaultNtt(uint256 newDefault) external onlyOwner
参数说明：
uint256 newDefault 所设置的默认信用分值

事件：
AdjustDefaultNtt(uint256 _newDefault);
参数说明：
uint256 _newDefault  所设置的默认信用分值
````

#### 查看账户是否能进行当前操作

````
function isAllow(address user, string calldata action) external view returns (bool)
参数说明：
address user 账户地址
string calldata action 查询的操作

返回值：
bool
true 能进行当前操作
false 不能进行当前操作
````

#### 设置行为要求的NTT分数值

```
function adjustNttRequirement(string calldata action, uint256 min) external onlyOwner
参数说明：
string  calldata action   所要设置的行为描述
uint256 min  ntt分数值

事件：
SetNttRquirement(string _action, uint256 _ntt);
参数说明：
string _action 设置的行为描述
uint256 _ntt 所需要的ntt值
```

