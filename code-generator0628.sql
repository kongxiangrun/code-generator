/*
Navicat MySQL Data Transfer

Source Server         : 127.0.0.1
Source Server Version : 50717
Source Host           : 127.0.0.1:3306
Source Database       : code-generator

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2020-06-28 18:41:22
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for t_code_bs_template
-- ----------------------------
DROP TABLE IF EXISTS `t_code_bs_template`;
CREATE TABLE `t_code_bs_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '初始模板ID',
  `type` varchar(20) DEFAULT NULL COMMENT '模板类型 ex: entity、service、mapper...',
  `file_suffix` varchar(20) DEFAULT NULL COMMENT '生成文件后缀名 .java',
  `content` text COMMENT '模板内容',
  `user_id` int(11) DEFAULT NULL COMMENT '所属用户ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='初始模板表';

-- ----------------------------
-- Records of t_code_bs_template
-- ----------------------------
INSERT INTO `t_code_bs_template` VALUES ('1', 'entity1', '.java', 'package ${package.Entity};\n\n#foreach($pkg in ${table.importPackages})\nimport ${pkg};\n#end\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * <p>  ${table.comment} </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n#if(${table.convert})\n@Data\n@ApiModel(description = \"${table.comment}\")\n@TableName(\"${table.name}\")\n#end\n#if(${superEntityClass})\npublic class ${entity} extends ${superEntityClass}#if(${activeRecord})<${entity}>#end {\n#elseif(${activeRecord})\npublic class ${entity} extends Model<${entity}> {\n#else\npublic class ${entity} implements Serializable {\n#end\n\n    private static final long serialVersionUID = 1L;\n\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})\n#set($keyPropertyName=${field.propertyName})\n#end\n#if(\"$!field.comment\" != \"\")\n    /**\n     * ${field.comment}\n     */\n	@ApiModelProperty(value = \"${field.comment}\")\n#end\n#if(${field.keyFlag})\n	@TableId(value=\"${field.name}\", type= IdType.AUTO)\n#else\n	@TableField(\"${field.name}\")\n#end\n	private ${field.propertyType} ${field.propertyName};\n#end\n\n#if(${entityColumnConstant})\n#foreach($field in ${table.fields})\n	public static final String ${field.name.toUpperCase()} = \"${field.name}\";\n\n#end\n#end\n#if(${activeRecord})\n	@Override\n	protected Serializable pkVal() {\n#if(${keyPropertyName})\n		return this.${keyPropertyName};\n#else\n		return this.id;\n#end\n	}\n\n#end\n}\n', '1', '2019-08-20 14:55:29', '2020-06-28 17:32:32');
INSERT INTO `t_code_bs_template` VALUES ('2', 'mapper.xml', '.xml', '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\">\n<mapper namespace=\"${package.Mapper}.${table.mapperName}\">\n\n#if(${enableCache})\n	<!-- 开启二级缓存 -->\n	<cache type=\"org.mybatis.caches.ehcache.LoggingEhcache\"/>\n\n#end\n#if(${baseResultMap})\n	<!-- 通用查询映射结果 -->\n	<resultMap id=\"BaseResultMap\" type=\"${package.Entity}.${entity}\">\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})##生成主键排在第一位\n		<id column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n#foreach($field in ${table.fields})\n#if(!${field.keyFlag})##生成普通字段\n		<result column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n	</resultMap>\n\n#end\n#if(${baseColumnList})\n    <!-- 通用查询结果列 -->\n    <sql id=\"Base_Column_List\">\n        ${table.fieldNames}\n    </sql>\n\n#end\n\n    <select id=\"select${entity}s\" resultMap=\"BaseResultMap\">\n        SELECT\n             *\n        FROM ${table.name}\n        WHERE\n             1 = 1\n        <if test=\"filter.id!=null and filter.id!=\'\'\">\n            AND	${entity}_ID= #{filter.id}\n        </if>\n        ORDER BY ${entity}_ID DESC\n    </select>\n\n</mapper>\n', '1', '2019-08-20 14:55:10', '2020-06-28 16:25:50');
INSERT INTO `t_code_bs_template` VALUES ('3', 'mapper', '.java', 'package ${package.Mapper};\n\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${superMapperClassPackage};\nimport com.baomidou.mybatisplus.plugins.pagination.Pagination;\nimport org.apache.ibatis.annotations.Param;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} Mapper 接口 </p>\n *\n * @author : zhengqing\n * @date : ${date}\n */\npublic interface ${table.mapperName} extends ${superMapperClass}<${entity}> {\n\n    /**\n     * 列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(Pagination page, @Param(\"filter\") ${formQueryPara} filter);\n\n    /**\n     * 列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(@Param(\"filter\") ${formQueryPara} filter);\n}', '1', '2019-08-20 14:54:39', '2019-09-18 09:03:47');
INSERT INTO `t_code_bs_template` VALUES ('4', ' service', '.java', 'package ${package.Service};\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport ${superServiceClassPackage};\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\n\nimport java.util.List;\n\n/**\n * <p>  ${table.comment} 服务类 </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\npublic interface ${table.serviceName} extends ${superServiceClass}<${entity}> {\n\n    /**\n     * ${table.comment}列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    void listPage(Page<${entity}> page, ${formQueryPara} filter);\n\n    /**\n     * 保存${table.comment}\n     *\n     * @param input\n     */\n    Integer save(${entity} input);\n\n    /**\n     * ${table.comment}列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> list(${formQueryPara} filter);\n}\n', '1', '2019-08-20 14:54:14', '2019-09-18 09:03:31');
INSERT INTO `t_code_bs_template` VALUES ('5', ' service.impl', '.java', 'package ${package.ServiceImpl};\n\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${package.Mapper}.${table.mapperName};\nimport ${package.Service}.${table.serviceName};\nimport ${superServiceImplClassPackage};\nimport com.baomidou.mybatisplus.plugins.Page;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.stereotype.Service;\nimport org.springframework.transaction.annotation.Transactional;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} 服务实现类 </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n@Service\n@Transactional\npublic class ${table.serviceImplName} extends ${superServiceImplClass}<${table.mapperName}, ${entity}> implements ${table.serviceName} {\n\n    @Autowired\n    ${table.mapperName} ${entityPropertyName}Mapper;\n\n    @Override\n    public void listPage(Page<${entity}> page, ${formQueryPara} filter) {\n        page.setRecords(${entityPropertyName}Mapper.select${entity}s(page, filter));\n    }\n\n    @Override\n    public List<${entity}> list(${formQueryPara} filter) {\n        return ${entityPropertyName}Mapper.select${entity}s(filter);\n    }\n\n    @Override\n    public Integer save(${entity} para) {\n        if (para.get${entity}Id()!=null) {\n            ${entityPropertyName}Mapper.updateById(para);\n        } else {\n            ${entityPropertyName}Mapper.insert(para);\n        }\n        return para.get${entity}Id();\n    }\n}\n', '1', '2019-08-20 14:53:45', '2019-09-18 09:03:18');
INSERT INTO `t_code_bs_template` VALUES ('6', 'controller', '.java', 'package ${package.Controller};\n\nimport com.zhengqing.modules.common.api.BaseController;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.web.bind.annotation.*;\n\nimport java.util.List;\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport com.zhengqing.modules.common.dto.output.ApiResult;\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${package.Service}.${table.serviceName};\nimport io.swagger.annotations.Api;\nimport io.swagger.annotations.ApiOperation;\n\n\n/**\n * <p> ${table.comment} 接口 </p>\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n *\n */\n@RestController\n@RequestMapping(\"/api#if(${package.ModuleName})/${package.ModuleName}#end/${table.entityPath}\")\n@Api(description = \"${table.comment}接口\")\npublic class ${table.controllerName} extends BaseController {\n\n    @Autowired\n    ${table.serviceName} ${entityPropertyName}Service;\n\n    @PostMapping(value = \"/listPage\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表分页\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult listPage(@RequestBody ${formQueryPara} filter) {\n        Page<${entity}> page = new Page<>(filter.getPage(),filter.getLimit());\n        ${entityPropertyName}Service.listPage(page, filter);\n        return ApiResult.ok(\"获取${table.comment}列表分页成功\", page);\n    }\n\n    @PostMapping(value = \"/list\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult list(@RequestBody ${formQueryPara} filter) {\n        List<${entity}> result = ${entityPropertyName}Service.list(filter);\n        return ApiResult.ok(\"获取${table.comment}列表成功\",result);\n    }\n\n    @PostMapping(value = \"/save\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"保存${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult save(@RequestBody ${entity} input) {\n        Integer id = ${entityPropertyName}Service.save(input);\n        return ApiResult.ok(\"保存${table.comment}成功\", id);\n    }\n\n    @PostMapping(value = \"/delete\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"删除${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult delete(@RequestBody ${formQueryPara} input) {\n        ${entityPropertyName}Service.deleteById(input.getId());\n        return ApiResult.ok(\"删除${table.comment}成功\");\n    }\n\n    @PostMapping(value = \"/getById\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}信息\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult getById(@RequestBody ${formQueryPara} input) {\n        ${entity} entity = ${entityPropertyName}Service.selectById(input.getId());\n        return ApiResult.ok(\"获取${table.comment}信息成功\", entity);\n    }\n\n}', '1', '2019-08-20 14:53:20', '2020-06-28 15:51:43');
INSERT INTO `t_code_bs_template` VALUES ('7', 'input', '.java', 'package ${package.QueryPara};\n\nimport com.zhengqing.modules.common.dto.input.BasePageQuery;\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * ${table.comment}查询参数\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n */\n@Data\n@ApiModel(description = \"${table.comment}查询参数\")\npublic class ${formQueryPara} extends BasePageQuery{\n    @ApiModelProperty(value = \"id\")\n    private int id;\n}\n', '1', '2019-08-20 14:52:44', '2019-09-18 09:02:41');
INSERT INTO `t_code_bs_template` VALUES ('8', 'vue', '.vue', '<template>\n  <div class=\"app-container\">\n    <cus-wraper>\n      <cus-filter-wraper>\n        #if(${queryFields})\n        #foreach($field in ${queryFields})\n        <el-input v-model=\"listQuery.${field.propertyName}\" placeholder=\"请输入${field.comment}\" style=\"width:200px\" clearable></el-input>\n        #end\n        <el-button type=\"primary\" @click=\"getList\" icon=\"el-icon-search\" v-waves>查询</el-button>\n        <el-button type=\"primary\" @click=\"handleCreate\" icon=\"el-icon-plus\" v-waves>添加</el-button>        \n        #end\n      </cus-filter-wraper>\n      <div class=\"table-container\">\n        <el-table v-loading=\"listLoading\" :data=\"list\" size=\"mini\" element-loading-text=\"Loading\" fit border highlight-current-row>\n	        #foreach($field in ${table.fields})\n	        #if(${field.propertyType.equals(\"Date\")})\n	        <el-table-column label=\"${field.comment}\" align=\"center\">\n	            <template slot-scope=\"scope\">\n	                <span>{{scope.row.${field.propertyName}|dateTimeFilter}}</span>\n	            </template>\n	        </el-table-column>\n	        #else\n	        <el-table-column label=\"${field.comment}\" prop=\"${field.propertyName}\" align=\"center\"></el-table-column>\n	        #end\n	        #end\n          <el-table-column align=\"center\" label=\"操作\">\n            <template slot-scope=\"scope\">\n              <el-button size=\"mini\" type=\"primary\" @click=\"handleUpdate(scope.row)\" icon=\"el-icon-edit\" plain v-waves>编辑</el-button>\n              <cus-del-btn @ok=\"handleDelete(scope.row)\"></cus-del-btn>\n            </template>\n          </el-table-column>\n        </el-table>\n        <!-- 分页 -->\n        <cus-pagination v-show=\"total>0\" :total=\"total\" :page.sync=\"listQuery.page\" :limit.sync=\"listQuery.limit\" @pagination=\"getList\"/>\n      </div>\n\n      <el-dialog :title=\"titleMap[dialogStatus]\" :visible.sync=\"dialogVisible\" width=\"40%\" @close=\"handleDialogClose\">\n        <el-form ref=\"dataForm\" :model=\"form\" :rules=\"rules\" label-width=\"100px\" class=\"demo-ruleForm\">\n        #foreach($field in ${table.fields})\n        <el-form-item label=\"${field.comment}:\" prop=\"${field.propertyName}\">\n            <el-input v-model=\"form.${field.propertyName}\"></el-input>\n        </el-form-item>\n        #end\n        </el-form>\n        <span slot=\"footer\" class=\"dialog-footer\">\n          <el-button @click=\"dialogVisible = false\" v-waves>取 消</el-button>\n          <el-button type=\"primary\" @click=\"submitForm\" v-waves>确 定</el-button>\n        </span>\n      </el-dialog>\n    </cus-wraper>\n  </div>\n</template>\n\n<script>\n import { get${entity}Page, save${entity}, delete${entity} } from \"@/api/${package.ModuleName}/${entityPropertyName}\";\n\nexport default {\n  data() {\n    return {\n      dialogVisible: false,\n      list: [],\n      listLoading: true,\n      total: 0,\n      listQuery: {\n        page: 1,\n        limit: 10,\n	    #if(${queryFields})\n	    #foreach($field in ${queryFields})\n	    ${field.propertyName}:undefined,\n	    #end\n	    #end\n      },\n      input: \'\',\n      form: {\n	     #foreach($field in ${table.fields})\n	     ${field.propertyName}: undefined, //${field.comment}\n	     #end\n      },\n     dialogStatus: \"\",\n     titleMap: {\n        update: \"编辑\",\n        create: \"创建\"\n     },\n     rules: {\n         name: [\n            { required: true, message: \'请输入项目名称\', trigger: \'blur\' }\n         ]\n      }\n    }\n  },\n  created() {\n    this.getList();\n  },\n  methods: {\n    getList() {\n      this.listLoading = true;\n      get${entity}Page(this.listQuery).then(response => {\n        this.list = response.data.records;\n    	this.total = response.data.total;\n    	this.listLoading = false;\n		});\n    },\n    handleCreate() {\n        this.resetForm();\n        this.dialogStatus = \"create\";\n        this.dialogVisible = true;\n    },\n    handleUpdate(row) {\n        this.form = Object.assign({}, row);\n        this.dialogStatus = \"update\";\n        this.dialogVisible = true;\n    },\n    handleDelete(row) {\n      #foreach($field in ${table.fields})\n		#if(${field.keyFlag})\n		 let id = row.${field.propertyName};\n		#end\n	  #end\n      delete${entity}(id).then(response => {\n            if (response.code == 200) {\n            this.getList();\n            this.submitOk(response.message);\n        } else {\n            this.submitFail(response.message);\n        }\n    });\n    },\n    submitForm() {\n    this.#[[$refs]]#.[\'dataForm\'].validate(valid => {\n        if (valid) {\n            save${entity}(this.form).then(response => {\n                if (response.code == 200) {\n                    this.getList();\n                    this.submitOk(response.message);\n                    this.dialogVisible = false;\n                } else {\n                     this.submitFail(response.message);\n                }\n        }).catch(err => { console.log(err);  });\n            }\n        });\n    },\n    resetForm() {\n        this.form = {\n            #foreach($field in ${table.fields})\n                ${field.propertyName}: undefined, //${field.comment}\n            #end\n        };\n    },\n    // 监听dialog关闭时的处理事件\n    handleDialogClose(){\n        if(this.$refs[\'dataForm\']){\n             this.$refs[\'dataForm\'].clearValidate(); // 清除整个表单的校验\n        }\n    }\n  }\n}\n</script>', '1', '2019-08-20 14:52:19', '2019-09-18 09:02:12');
INSERT INTO `t_code_bs_template` VALUES ('9', 'js', '.js', 'import request from \'@/utils/request\';\n\nexport function get${entity}Page(query) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/listPage\',\n        method: \'post\',\n        data: query\n    });\n}\n\nexport function save${entity}(form) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/save\',\n        method: \'post\',\n        data: form\n    });\n}\n\nexport function delete${entity}(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/delete\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}\n\nexport function get${entity}ById(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/getById\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}', '1', '2019-08-17 18:13:10', '2019-09-17 17:57:43');
INSERT INTO `t_code_bs_template` VALUES ('10', 'entity', '.java', 'package ${package.Entity};\n\n#foreach($pkg in ${table.importPackages})\nimport ${pkg};\n#end\n \n\n/**\n * <p>  ${table.comment} </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n#if(${table.convert})\n@Data\n@ApiModel(description = \"${table.comment}\")\n@TableName(\"${table.name}\")\n#end \npublic class ${entity}  {\n\n \n\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})\n#set($keyPropertyName=${field.propertyName})\n#end\n#if(\"$!field.comment\" != \"\")\n    /**\n     * ${field.comment}\n     */\n	@ApiModelProperty(value = \"${field.comment}\")\n#end\n#if(${field.keyFlag})\n	@TableId(value=\"${field.name}\", type= IdType.AUTO)\n#else\n	@TableField(\"${field.name}\")\n#end\n	private ${field.propertyType} ${field.propertyName};\n#end\n\n#if(${entityColumnConstant})\n#foreach($field in ${table.fields})\n	public static final String ${field.name.toUpperCase()} = \"${field.name}\";\n\n#end\n#end\n#if(${activeRecord})\n	@Override\n	protected Serializable pkVal() {\n#if(${keyPropertyName})\n		return this.${keyPropertyName};\n#else\n		return this.id;\n#end\n	}\n\n#end\n}\n', '1', '2020-06-28 17:32:42', '2020-06-28 17:38:44');

-- ----------------------------
-- Table structure for t_code_database
-- ----------------------------
DROP TABLE IF EXISTS `t_code_database`;
CREATE TABLE `t_code_database` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '数据库ID',
  `project_id` int(11) DEFAULT NULL COMMENT '所属项目ID',
  `name` varchar(50) DEFAULT NULL COMMENT '数据库名称',
  `url` varchar(255) DEFAULT NULL COMMENT '数据库连接',
  `user` varchar(50) DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) DEFAULT NULL COMMENT '密码',
  `db_schema` varchar(50) DEFAULT NULL COMMENT 'SCHEMA',
  `db_type` tinyint(2) DEFAULT '1' COMMENT '数据库类型 1:mysql  2:oracle',
  `driver` varchar(255) DEFAULT NULL COMMENT '驱动程序',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='数据库信息表';

-- ----------------------------
-- Records of t_code_database
-- ----------------------------
INSERT INTO `t_code_database` VALUES ('2', '1', 'world', 'jdbc:mysql://127.0.0.1:3306/world', 'root', 'root', 'world', '1', 'com.mysql.jdbc.Driver', '2019-09-13 03:01:15', '2020-06-27 17:58:10');
INSERT INTO `t_code_database` VALUES ('3', '4', 'world2', 'jdbc:mysql://127.0.0.1:3306/world', 'root', 'root', 'world', '1', 'com.mysql.jdbc.Driver', '2020-06-28 17:50:52', '2020-06-28 17:52:43');

-- ----------------------------
-- Table structure for t_code_project
-- ----------------------------
DROP TABLE IF EXISTS `t_code_project`;
CREATE TABLE `t_code_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `name` varchar(50) CHARACTER SET utf8 DEFAULT '' COMMENT '项目名称',
  `user_id` int(11) DEFAULT NULL COMMENT '所属用户ID',
  `status` bit(1) DEFAULT NULL COMMENT '状态：是否启用  0:停用  1:启用',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='代码生成器 - 项目管理表';

-- ----------------------------
-- Records of t_code_project
-- ----------------------------
INSERT INTO `t_code_project` VALUES ('1', '项目demo', '1', '', '2019-09-10 13:56:35', '2019-09-12 19:25:28');
INSERT INTO `t_code_project` VALUES ('4', 'test', '1', '', '2020-06-28 16:14:53', '2020-06-28 16:14:53');

-- ----------------------------
-- Table structure for t_code_project_package
-- ----------------------------
DROP TABLE IF EXISTS `t_code_project_package`;
CREATE TABLE `t_code_project_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '包ID',
  `name` varchar(100) DEFAULT NULL COMMENT '包名',
  `parent_id` int(11) DEFAULT NULL COMMENT '父包ID',
  `project_id` int(11) DEFAULT NULL COMMENT '关联项目ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='代码生成器 - 项目包管理表';

-- ----------------------------
-- Records of t_code_project_package
-- ----------------------------
INSERT INTO `t_code_project_package` VALUES ('1', 'com.codestrike.user', '0', '1', '2019-09-10 13:56:35', '2020-06-28 15:52:34');
INSERT INTO `t_code_project_package` VALUES ('2', 'common', '1', '1', '2019-09-10 13:56:35', '2019-09-10 13:56:35');
INSERT INTO `t_code_project_package` VALUES ('3', 'entity', '1', '1', '2019-09-10 13:56:35', '2019-09-10 13:56:35');
INSERT INTO `t_code_project_package` VALUES ('4', 'service', '1', '1', '2019-09-10 13:56:35', '2019-09-10 13:56:35');
INSERT INTO `t_code_project_package` VALUES ('5', 'service.impl', '1', '1', '2019-09-10 13:56:35', '2019-09-17 12:41:00');
INSERT INTO `t_code_project_package` VALUES ('6', 'mapper', '1', '1', '2019-09-10 13:56:35', '2019-09-10 13:56:35');
INSERT INTO `t_code_project_package` VALUES ('7', 'mapper.xml', '1', '1', '2019-09-10 13:56:35', '2019-09-17 12:41:07');
INSERT INTO `t_code_project_package` VALUES ('18', 'api', '1', '1', '2019-09-12 19:08:07', '2019-09-12 19:08:07');
INSERT INTO `t_code_project_package` VALUES ('19', 'js', '1', '1', '2019-09-12 21:20:04', '2019-09-12 21:21:18');
INSERT INTO `t_code_project_package` VALUES ('20', 'vue', '1', '1', '2019-09-12 21:21:27', '2019-09-12 21:21:27');
INSERT INTO `t_code_project_package` VALUES ('21', 'dto', '1', '1', '2019-09-12 21:58:47', '2019-09-12 21:58:47');
INSERT INTO `t_code_project_package` VALUES ('22', 'input', '21', '1', '2019-09-12 21:58:58', '2019-09-12 21:58:58');
INSERT INTO `t_code_project_package` VALUES ('25', 'com.test', '0', '4', '2020-06-28 16:14:53', '2020-06-28 16:14:53');
INSERT INTO `t_code_project_package` VALUES ('27', 'mapper', '25', '4', '2020-06-28 16:16:05', '2020-06-28 16:18:59');
INSERT INTO `t_code_project_package` VALUES ('28', 'mapper.xml', '25', '4', '2020-06-28 16:23:48', '2020-06-28 16:24:29');

-- ----------------------------
-- Table structure for t_code_project_template
-- ----------------------------
DROP TABLE IF EXISTS `t_code_project_template`;
CREATE TABLE `t_code_project_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `project_id` int(11) DEFAULT NULL COMMENT '项目ID',
  `type` int(11) DEFAULT NULL COMMENT '模板类型 - 对应包ID',
  `file_suffix` varchar(20) DEFAULT NULL COMMENT '生成文件后缀名 .java',
  `content` text COMMENT '模板内容',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目代码模板表';

-- ----------------------------
-- Records of t_code_project_template
-- ----------------------------
INSERT INTO `t_code_project_template` VALUES ('19', '1', '3', '.java', 'package ${package.entity};\n\n#foreach($pkg in ${table.importPackages})\nimport ${pkg};\n#end\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * <p>  ${table.comment} </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n#if(${table.convert})\n@Data\n@ApiModel(description = \"${table.comment}\")\n@TableName(\"${table.name}\")\n#end\n#if(${superEntityClass})\npublic class ${entity} extends ${superEntityClass}#if(${activeRecord})<${entity}>#end {\n#elseif(${activeRecord})\npublic class ${entity} extends Model<${entity}> {\n#else\npublic class ${entity} implements Serializable {\n#end\n\n    private static final long serialVersionUID = 1L;\n\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})\n#set($keyPropertyName=${field.propertyName})\n#end\n#if(\"$!field.comment\" != \"\")\n    /**\n     * ${field.comment}\n     */\n	@ApiModelProperty(value = \"${field.comment}\")\n#end\n#if(${field.keyFlag})\n	@TableId(value=\"${field.name}\", type= IdType.AUTO)\n#else\n	@TableField(\"${field.name}\")\n#end\n	private ${field.propertyType} ${field.propertyName};\n#end\n\n#if(${entityColumnConstant})\n#foreach($field in ${table.fields})\n	public static final String ${field.name.toUpperCase()} = \"${field.name}\";\n\n#end\n#end\n#if(${activeRecord})\n	@Override\n	protected Serializable pkVal() {\n#if(${keyPropertyName})\n		return this.${keyPropertyName};\n#else\n		return this.id;\n#end\n	}\n\n#end\n}\n', '2019-09-11 21:40:06', '2019-09-18 09:16:01');
INSERT INTO `t_code_project_template` VALUES ('20', '1', '7', '.xml', '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\">\n<mapper namespace=\"${package.mapper}.${tableInfo.mapper}\">\n\n#if(${enableCache})\n	<!-- 开启二级缓存 -->\n	<cache type=\"org.mybatis.caches.ehcache.LoggingEhcache\"/>\n\n#end\n#if(${baseResultMap})\n	<!-- 通用查询映射结果 -->\n	<resultMap id=\"BaseResultMap\" type=\"${package.entity}.${entity}\">\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})##生成主键排在第一位\n		<id column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n#foreach($field in ${table.fields})\n#if(!${field.keyFlag})##生成普通字段\n		<result column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n	</resultMap>\n\n#end\n#if(${baseColumnList})\n    <!-- 通用查询结果列 -->\n    <sql id=\"Base_Column_List\">\n        ${table.fieldNames}\n    </sql>\n\n#end\n\n  <!--    <resultMap id=\"ResultMap\" type=\"com.zhengqing.modules.system.dto.output.RoleView\" extends=\"BaseResultMap\"></resultMap>-->\n\n    <select id=\"select${entity}s\" resultMap=\"BaseResultMap\">\n        SELECT\n             *\n        FROM ${table.name}\n        WHERE\n             1 = 1\n        <if test=\"filter.id!=null and filter.id!=\'\'\">\n            AND id = #{filter.id}\n        </if>\n        ORDER BY id DESC\n    </select>\n\n</mapper>\n', '2019-09-11 21:40:06', '2019-09-18 09:23:40');
INSERT INTO `t_code_project_template` VALUES ('21', '1', '6', '.java', 'package ${package.mapper};\n\nimport ${package.entity}.${entity};\nimport ${package.input}.${tableInfo.input};\nimport ${superMapperClassPackage};\nimport com.baomidou.mybatisplus.plugins.pagination.Pagination;\nimport org.apache.ibatis.annotations.Param;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} Mapper 接口 </p>\n *\n * @author : zhengqing\n * @date : ${date}\n */\npublic interface ${tableInfo.mapper} extends ${superMapperClass}<${entity}> {\n\n    /**\n     * 列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(Pagination page, @Param(\"filter\") ${tableInfo.input} filter);\n\n    /**\n     * 列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(@Param(\"filter\") ${tableInfo.input} filter);\n\n}', '2019-09-11 21:40:06', '2019-09-18 10:57:06');
INSERT INTO `t_code_project_template` VALUES ('22', '1', '4', '.java', 'package ${package.service};\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport ${superServiceClassPackage};\nimport ${package.entity}.${entity};\nimport ${package.input}.${tableInfo.input};\n\nimport java.util.List;\n\n/**\n * <p>  ${table.comment} 服务类 </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\npublic interface ${tableInfo.service} extends ${superServiceClass}<${entity}> {\n\n    /**\n     * ${table.comment}列表分页\n     *\n     * @param page\n     * @param para\n     * @return\n     */\n    void listPage(Page<${entity}> page, ${tableInfo.input} para);\n\n    /**\n     * 保存${table.comment}\n     *\n     * @param input\n     */\n    Integer save(${entity} input);\n\n    /**\n     * ${table.comment}列表\n     *\n     * @param para\n     * @return\n     */\n    List<${entity}> list(${tableInfo.input} para);\n\n}\n', '2019-09-11 21:40:06', '2019-09-18 09:39:08');
INSERT INTO `t_code_project_template` VALUES ('23', '1', '5', '.java', 'package ${service}.impl.${tableInfo.service}Impl;\n\nimport ${package.entity}.${entity};\nimport ${package.input}.${tableInfo.input};\nimport ${package.mapper}.${tableInfo.mapper};\nimport ${package.service}.${tableInfo.service};\nimport ${superServiceImplClassPackage};\nimport com.baomidou.mybatisplus.plugins.Page;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.stereotype.Service;\nimport org.springframework.transaction.annotation.Transactional;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} 服务实现类 </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n@Service\n@Transactional\npublic class ${tableInfo.service}Impl extends ${superServiceImplClass}<${tableInfo.mapper}, ${entity}> implements ${tableInfo.service} {\n\n    @Autowired\n    ${tableInfo.mapper} ${entityPropertyName}Mapper;\n\n    @Override\n    public void listPage(Page<${entity}> page, ${tableInfo.input} para) {\n        page.setRecords(${entityPropertyName}Mapper.select${entity}s(page, para));\n    }\n\n    @Override\n    public List<${entity}> list(${tableInfo.input} para) {\n        return ${entityPropertyName}Mapper.select${entity}s(para);\n    }\n\n    @Override\n    public Integer save(${entity} para) {\n        if (para.getId()!=null) {\n            ${entityPropertyName}Mapper.updateById(para);\n        } else {\n            ${entityPropertyName}Mapper.insert(para);\n        }\n        return para.getId();\n    }\n}\n', '2019-09-11 21:40:06', '2019-09-18 10:56:23');
INSERT INTO `t_code_project_template` VALUES ('24', '1', '18', '.java', 'package ${package.api};\n\nimport com.zhengqing.modules.common.api.BaseController;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.web.bind.annotation.*;\n\nimport java.util.List;\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport com.zhengqing.modules.common.dto.output.ApiResult;\nimport ${package.entity}.${entity};\nimport ${package.input}.${tableInfo.input};\nimport ${package.service}.${tableInfo.service};\nimport io.swagger.annotations.Api;\nimport io.swagger.annotations.ApiOperation;\n\n\n/**\n * <p> ${table.comment} 接口 </p>\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n *\n */\n@RestController\n@RequestMapping(\"/api#if(${package.moduleName})/${package.moduleName}#end/${table.entityPath}\")\n@Api(description = \"${table.comment}接口\")\npublic class ${tableInfo.api} extends BaseController {\n\n    @Autowired\n    ${tableInfo.service} ${entityPropertyName}Service;\n\n    @PostMapping(value = \"/listPage\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表分页\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult listPage(@RequestBody ${tableInfo.input} filter) {\n        Page<${entity}> page = new Page<>(filter.getPage(),filter.getLimit());\n        ${entityPropertyName}Service.listPage(page, filter);\n        return ApiResult.ok(\"获取${table.comment}列表分页成功\", page);\n    }\n\n    @PostMapping(value = \"/list\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult list(@RequestBody ${tableInfo.input} filter) {\n        List<${entity}> result = ${entityPropertyName}Service.list(filter);\n        return ApiResult.ok(\"获取${table.comment}列表成功\",result);\n    }\n\n    @PostMapping(value = \"/saveOrUpdate\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"保存或更新${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult saveOrUpdate(@RequestBody ${entity} input) {\n        Integer id = ${entityPropertyName}Service.save(input);\n        return ApiResult.ok(\"保存${table.comment}成功\", id);\n    }\n\n    @PostMapping(value = \"/delete\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"删除${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult delete(@RequestBody ${tableInfo.input} input) {\n        ${entityPropertyName}Service.deleteById(input.getId());\n        return ApiResult.ok(\"删除${table.comment}成功\");\n    }\n\n    @PostMapping(value = \"/detail\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"根据ID获取${table.comment}信息\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult detail(@RequestBody ${tableInfo.input} input) {\n        ${entity} entity = ${entityPropertyName}Service.selectById(input.getId());\n        return ApiResult.ok(\"根据ID获取${table.comment}信息成功\", entity);\n    }\n\n}', '2019-09-11 21:40:06', '2019-09-18 09:20:46');
INSERT INTO `t_code_project_template` VALUES ('25', '1', '22', '.java', 'package ${package.input};\n\nimport com.zhengqing.modules.common.dto.input.BasePageQuery;\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * ${table.comment}查询参数\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n */\n@Data\n@ApiModel(description = \"${table.comment}查询参数\")\npublic class ${tableInfo.input} extends BasePageQuery{\n    @ApiModelProperty(value = \"id\")\n    private Integer id;\n}\n', '2019-09-11 21:40:06', '2019-09-18 09:09:56');
INSERT INTO `t_code_project_template` VALUES ('26', '1', '20', '.vue', '<template>\n  <div class=\"app-container\">\n    <cus-wraper>\n      <cus-filter-wraper>\n        #if(${queryFields})\n        #foreach($field in ${queryFields})\n        <el-input v-model=\"listQuery.${field.propertyName}\" placeholder=\"请输入${field.comment}\" style=\"width:200px\" clearable></el-input>\n        #end\n        <el-button type=\"primary\" @click=\"getList\" icon=\"el-icon-search\" v-waves>查询</el-button>\n        <el-button type=\"primary\" @click=\"handleCreate\" icon=\"el-icon-plus\" v-waves>添加</el-button>        \n        #end\n      </cus-filter-wraper>\n      <div class=\"table-container\">\n        <el-table v-loading=\"listLoading\" :data=\"list\" size=\"mini\" element-loading-text=\"Loading\" fit border highlight-current-row>\n	        #foreach($field in ${table.fields})\n	        #if(${field.propertyType.equals(\"Date\")})\n	        <el-table-column label=\"${field.comment}\" align=\"center\">\n	            <template slot-scope=\"scope\">\n	                <span>{{scope.row.${field.propertyName}|dateTimeFilter}}</span>\n	            </template>\n	        </el-table-column>\n	        #else\n	        <el-table-column label=\"${field.comment}\" prop=\"${field.propertyName}\" align=\"center\"></el-table-column>\n	        #end\n	        #end\n          <el-table-column align=\"center\" label=\"操作\">\n            <template slot-scope=\"scope\">\n              <el-button size=\"mini\" type=\"primary\" @click=\"handleUpdate(scope.row)\" icon=\"el-icon-edit\" plain v-waves>编辑</el-button>\n              <cus-del-btn @ok=\"handleDelete(scope.row)\"></cus-del-btn>\n            </template>\n          </el-table-column>\n        </el-table>\n        <!-- 分页 -->\n        <cus-pagination v-show=\"total>0\" :total=\"total\" :page.sync=\"listQuery.page\" :limit.sync=\"listQuery.limit\" @pagination=\"getList\"/>\n      </div>\n\n      <el-dialog :title=\"titleMap[dialogStatus]\" :visible.sync=\"dialogVisible\" width=\"40%\" @close=\"handleDialogClose\">\n        <el-form ref=\"dataForm\" :model=\"form\" :rules=\"rules\" label-width=\"100px\" class=\"demo-ruleForm\">\n        #foreach($field in ${table.fields})\n        <el-form-item label=\"${field.comment}:\" prop=\"${field.propertyName}\">\n            <el-input v-model=\"form.${field.propertyName}\"></el-input>\n        </el-form-item>\n        #end\n        </el-form>\n        <span slot=\"footer\" class=\"dialog-footer\">\n          <el-button @click=\"dialogVisible = false\" v-waves>取 消</el-button>\n          <el-button type=\"primary\" @click=\"submitForm\" v-waves>确 定</el-button>\n        </span>\n      </el-dialog>\n    </cus-wraper>\n  </div>\n</template>\n\n<script>\n import { get${entity}Page, saveOrUpdate${entity}, delete${entity} } from \"@/api/${package.moduleName}/${entityPropertyName}\";\n\nexport default {\n  name: \'${entity}\',\n  data() {\n    return {\n      dialogVisible: false,\n      list: [],\n      listLoading: true,\n      total: 0,\n      listQuery: {\n        page: 1,\n        limit: 10,\n	    #if(${queryFields})\n	    #foreach($field in ${queryFields})\n	    ${field.propertyName}:undefined,\n	    #end\n	    #end\n      },\n      input: \'\',\n      form: {\n	     #foreach($field in ${table.fields})\n	     ${field.propertyName}: undefined, //${field.comment}\n	     #end\n      },\n     dialogStatus: \"\",\n     titleMap: {\n        update: \"编辑\",\n        create: \"创建\"\n     },\n     rules: {\n         name: [\n            { required: true, message: \'请输入项目名称\', trigger: \'blur\' }\n         ]\n      }\n    }\n  },\n  created() {\n    this.getList();\n  },\n  methods: {\n    getList() {\n      this.listLoading = true;\n      get${entity}Page(this.listQuery).then(response => {\n        this.list = response.data.records;\n    	this.total = response.data.total;\n    	this.listLoading = false;\n		});\n    },\n    handleCreate() {\n        this.resetForm();\n        this.dialogStatus = \"create\";\n        this.dialogVisible = true;\n    },\n    handleUpdate(row) {\n        this.form = Object.assign({}, row);\n        this.dialogStatus = \"update\";\n        this.dialogVisible = true;\n    },\n    handleDelete(row) {\n      #foreach($field in ${table.fields})\n		#if(${field.keyFlag})\n		 let id = row.${field.propertyName};\n		#end\n	  #end\n      delete${entity}(id).then(response => {\n            if (response.code == 200) {\n            this.getList();\n            this.submitOk(response.message);\n        } else {\n            this.submitFail(response.message);\n        }\n    });\n    },\n    submitForm() {\n    this.#[[$refs]]#.dataForm.validate(valid => {\n        if (valid) {\n            saveOrUpdate${entity}(this.form).then(response => {\n                if (response.code == 200) {\n                    this.getList();\n                    this.submitOk(response.message);\n                    this.dialogVisible = false;\n                } else {\n                     this.submitFail(response.message);\n                }\n        }).catch(err => { console.log(err);  });\n            }\n        });\n    },\n    resetForm() {\n        this.form = {\n            #foreach($field in ${table.fields})\n                ${field.propertyName}: undefined, //${field.comment}\n            #end\n        };\n    },\n    // 监听dialog关闭时的处理事件\n    handleDialogClose(){\n        if(this.$refs[\'dataForm\']){\n             this.$refs[\'dataForm\'].clearValidate(); // 清除整个表单的校验\n        }\n    }\n  }\n}\n</script>\n', '2019-09-11 21:40:06', '2019-09-18 09:32:20');
INSERT INTO `t_code_project_template` VALUES ('27', '1', '19', '.js', 'import request from \'@/utils/request\';\n\nexport function get${entity}Page(query) {\n    return request({\n        url: \'/api/${package.moduleName}/${entityPropertyName}/listPage\',\n        method: \'post\',\n        data: query\n    });\n}\n\nexport function saveOrUpdate${entity}(form) {\n    return request({\n        url: \'/api/${package.moduleName}/${entityPropertyName}/saveOrUpdate\',\n        method: \'post\',\n        data: form\n    });\n}\n\nexport function delete${entity}(id) {\n    return request({\n        url: \'/api/${package.moduleName}/${entityPropertyName}/delete\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}\n\nexport function get${entity}ById(id) {\n    return request({\n        url: \'/api/${package.moduleName}/${entityPropertyName}/detail\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}', '2019-09-11 21:40:06', '2019-09-14 22:20:44');
INSERT INTO `t_code_project_template` VALUES ('41', '1', '3', '.java', 'package ${package.Entity};\n\n#foreach($pkg in ${table.importPackages})\nimport ${pkg};\n#end\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * <p>  ${table.comment} </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n#if(${table.convert})\n@Data\n@ApiModel(description = \"${table.comment}\")\n@TableName(\"${table.name}\")\n#end\n#if(${superEntityClass})\npublic class ${entity} extends ${superEntityClass}#if(${activeRecord})<${entity}>#end {\n#elseif(${activeRecord})\npublic class ${entity} extends Model<${entity}> {\n#else\npublic class ${entity} implements Serializable {\n#end\n\n    private static final long serialVersionUID = 1L;\n\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})\n#set($keyPropertyName=${field.propertyName})\n#end\n#if(\"$!field.comment\" != \"\")\n    /**\n     * ${field.comment}\n     */\n	@ApiModelProperty(value = \"${field.comment}\")\n#end\n#if(${field.keyFlag})\n	@TableId(value=\"${field.name}\", type= IdType.AUTO)\n#else\n	@TableField(\"${field.name}\")\n#end\n	private ${field.propertyType} ${field.propertyName};\n#end\n\n#if(${entityColumnConstant})\n#foreach($field in ${table.fields})\n	public static final String ${field.name.toUpperCase()} = \"${field.name}\";\n\n#end\n#end\n#if(${activeRecord})\n	@Override\n	protected Serializable pkVal() {\n#if(${keyPropertyName})\n		return this.${keyPropertyName};\n#else\n		return this.id;\n#end\n	}\n\n#end\n}\n', '2020-06-27 17:52:53', '2020-06-27 17:52:53');
INSERT INTO `t_code_project_template` VALUES ('42', '1', '6', '.java', 'package ${package.Mapper};\n\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${superMapperClassPackage};\nimport com.baomidou.mybatisplus.plugins.pagination.Pagination;\nimport org.apache.ibatis.annotations.Param;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} Mapper 接口 </p>\n *\n * @author : zhengqing\n * @date : ${date}\n */\npublic interface ${table.mapperName} extends ${superMapperClass}<${entity}> {\n\n    /**\n     * 列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(Pagination page, @Param(\"filter\") ${formQueryPara} filter);\n\n    /**\n     * 列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(@Param(\"filter\") ${formQueryPara} filter);\n}', '2020-06-27 17:52:53', '2020-06-27 17:52:53');
INSERT INTO `t_code_project_template` VALUES ('43', '1', '18', '.java', 'package ${package.Controller};\n\nimport com.zhengqing.modules.common.api.BaseController;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.web.bind.annotation.*;\n\nimport java.util.List;\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport com.zhengqing.modules.common.dto.output.ApiResult;\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${package.Service}.${table.serviceName};\nimport io.swagger.annotations.Api;\nimport io.swagger.annotations.ApiOperation;\n\n\n/**\n * <p> ${table.comment} 接口 </p>\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n *\n */\n@RestController\n@RequestMapping(\"/api#if(${package.ModuleName})/${package.ModuleName}#end/${table.entityPath}\")\n@Api(description = \"${table.comment}接口\")\npublic class ${table.controllerName} extends BaseController {\n\n    @Autowired\n    ${table.serviceName} ${entityPropertyName}Service;\n\n    @PostMapping(value = \"/listPage\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表分页\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult listPage(@RequestBody ${formQueryPara} filter) {\n        Page<${entity}> page = new Page<>(filter.getPage(),filter.getLimit());\n        ${entityPropertyName}Service.listPage(page, filter);\n        return ApiResult.ok(\"获取${table.comment}列表分页成功\", page);\n    }\n\n    @PostMapping(value = \"/list\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult list(@RequestBody ${formQueryPara} filter) {\n        List<${entity}> result = ${entityPropertyName}Service.list(filter);\n        return ApiResult.ok(\"获取${table.comment}列表成功\",result);\n    }\n\n    @PostMapping(value = \"/save\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"保存${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult save(@RequestBody ${entity} input) {\n        Integer id = ${entityPropertyName}Service.save(input);\n        return ApiResult.ok(\"保存${table.comment}成功\", id);\n    }\n\n    @PostMapping(value = \"/delete\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"删除${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult delete(@RequestBody ${formQueryPara} input) {\n        ${entityPropertyName}Service.deleteById(input.getId());\n        return ApiResult.ok(\"删除${table.comment}成功\");\n    }\n\n    @PostMapping(value = \"/getById\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}信息\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult getById(@RequestBody ${formQueryPara} input) {\n        ${entity} entity = ${entityPropertyName}Service.selectById(input.getId());\n        return ApiResult.ok(\"获取${table.comment}信息成功\", entity);\n    }\n\n}', '2020-06-27 17:52:53', '2020-06-27 17:52:53');
INSERT INTO `t_code_project_template` VALUES ('44', '1', '22', '.java', 'package ${package.QueryPara};\n\nimport com.zhengqing.modules.common.dto.input.BasePageQuery;\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * ${table.comment}查询参数\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n */\n@Data\n@ApiModel(description = \"${table.comment}查询参数\")\npublic class ${formQueryPara} extends BasePageQuery{\n    @ApiModelProperty(value = \"id\")\n    private int id;\n}\n', '2020-06-27 17:52:53', '2020-06-27 17:52:53');
INSERT INTO `t_code_project_template` VALUES ('45', '1', '20', '.vue', '<template>\n  <div class=\"app-container\">\n    <cus-wraper>\n      <cus-filter-wraper>\n        #if(${queryFields})\n        #foreach($field in ${queryFields})\n        <el-input v-model=\"listQuery.${field.propertyName}\" placeholder=\"请输入${field.comment}\" style=\"width:200px\" clearable></el-input>\n        #end\n        <el-button type=\"primary\" @click=\"getList\" icon=\"el-icon-search\" v-waves>查询</el-button>\n        <el-button type=\"primary\" @click=\"handleCreate\" icon=\"el-icon-plus\" v-waves>添加</el-button>        \n        #end\n      </cus-filter-wraper>\n      <div class=\"table-container\">\n        <el-table v-loading=\"listLoading\" :data=\"list\" size=\"mini\" element-loading-text=\"Loading\" fit border highlight-current-row>\n	        #foreach($field in ${table.fields})\n	        #if(${field.propertyType.equals(\"Date\")})\n	        <el-table-column label=\"${field.comment}\" align=\"center\">\n	            <template slot-scope=\"scope\">\n	                <span>{{scope.row.${field.propertyName}|dateTimeFilter}}</span>\n	            </template>\n	        </el-table-column>\n	        #else\n	        <el-table-column label=\"${field.comment}\" prop=\"${field.propertyName}\" align=\"center\"></el-table-column>\n	        #end\n	        #end\n          <el-table-column align=\"center\" label=\"操作\">\n            <template slot-scope=\"scope\">\n              <el-button size=\"mini\" type=\"primary\" @click=\"handleUpdate(scope.row)\" icon=\"el-icon-edit\" plain v-waves>编辑</el-button>\n              <cus-del-btn @ok=\"handleDelete(scope.row)\"></cus-del-btn>\n            </template>\n          </el-table-column>\n        </el-table>\n        <!-- 分页 -->\n        <cus-pagination v-show=\"total>0\" :total=\"total\" :page.sync=\"listQuery.page\" :limit.sync=\"listQuery.limit\" @pagination=\"getList\"/>\n      </div>\n\n      <el-dialog :title=\"titleMap[dialogStatus]\" :visible.sync=\"dialogVisible\" width=\"40%\" @close=\"handleDialogClose\">\n        <el-form ref=\"dataForm\" :model=\"form\" :rules=\"rules\" label-width=\"100px\" class=\"demo-ruleForm\">\n        #foreach($field in ${table.fields})\n        <el-form-item label=\"${field.comment}:\" prop=\"${field.propertyName}\">\n            <el-input v-model=\"form.${field.propertyName}\"></el-input>\n        </el-form-item>\n        #end\n        </el-form>\n        <span slot=\"footer\" class=\"dialog-footer\">\n          <el-button @click=\"dialogVisible = false\" v-waves>取 消</el-button>\n          <el-button type=\"primary\" @click=\"submitForm\" v-waves>确 定</el-button>\n        </span>\n      </el-dialog>\n    </cus-wraper>\n  </div>\n</template>\n\n<script>\n import { get${entity}Page, save${entity}, delete${entity} } from \"@/api/${package.ModuleName}/${entityPropertyName}\";\n\nexport default {\n  data() {\n    return {\n      dialogVisible: false,\n      list: [],\n      listLoading: true,\n      total: 0,\n      listQuery: {\n        page: 1,\n        limit: 10,\n	    #if(${queryFields})\n	    #foreach($field in ${queryFields})\n	    ${field.propertyName}:undefined,\n	    #end\n	    #end\n      },\n      input: \'\',\n      form: {\n	     #foreach($field in ${table.fields})\n	     ${field.propertyName}: undefined, //${field.comment}\n	     #end\n      },\n     dialogStatus: \"\",\n     titleMap: {\n        update: \"编辑\",\n        create: \"创建\"\n     },\n     rules: {\n         name: [\n            { required: true, message: \'请输入项目名称\', trigger: \'blur\' }\n         ]\n      }\n    }\n  },\n  created() {\n    this.getList();\n  },\n  methods: {\n    getList() {\n      this.listLoading = true;\n      get${entity}Page(this.listQuery).then(response => {\n        this.list = response.data.records;\n    	this.total = response.data.total;\n    	this.listLoading = false;\n		});\n    },\n    handleCreate() {\n        this.resetForm();\n        this.dialogStatus = \"create\";\n        this.dialogVisible = true;\n    },\n    handleUpdate(row) {\n        this.form = Object.assign({}, row);\n        this.dialogStatus = \"update\";\n        this.dialogVisible = true;\n    },\n    handleDelete(row) {\n      #foreach($field in ${table.fields})\n		#if(${field.keyFlag})\n		 let id = row.${field.propertyName};\n		#end\n	  #end\n      delete${entity}(id).then(response => {\n            if (response.code == 200) {\n            this.getList();\n            this.submitOk(response.message);\n        } else {\n            this.submitFail(response.message);\n        }\n    });\n    },\n    submitForm() {\n    this.#[[$refs]]#.[\'dataForm\'].validate(valid => {\n        if (valid) {\n            save${entity}(this.form).then(response => {\n                if (response.code == 200) {\n                    this.getList();\n                    this.submitOk(response.message);\n                    this.dialogVisible = false;\n                } else {\n                     this.submitFail(response.message);\n                }\n        }).catch(err => { console.log(err);  });\n            }\n        });\n    },\n    resetForm() {\n        this.form = {\n            #foreach($field in ${table.fields})\n                ${field.propertyName}: undefined, //${field.comment}\n            #end\n        };\n    },\n    // 监听dialog关闭时的处理事件\n    handleDialogClose(){\n        if(this.$refs[\'dataForm\']){\n             this.$refs[\'dataForm\'].clearValidate(); // 清除整个表单的校验\n        }\n    }\n  }\n}\n</script>', '2020-06-27 17:52:53', '2020-06-27 17:52:53');
INSERT INTO `t_code_project_template` VALUES ('46', '1', '19', '.js', 'import request from \'@/utils/request\';\n\nexport function get${entity}Page(query) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/listPage\',\n        method: \'post\',\n        data: query\n    });\n}\n\nexport function save${entity}(form) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/save\',\n        method: \'post\',\n        data: form\n    });\n}\n\nexport function delete${entity}(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/delete\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}\n\nexport function get${entity}ById(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/getById\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}', '2020-06-27 17:52:53', '2020-06-27 17:52:53');
INSERT INTO `t_code_project_template` VALUES ('54', '4', '28', '.xml', '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\">\n<mapper namespace=\"${package.Mapper}.${table.mapperName}\">\n\n#if(${enableCache})\n	<!-- 开启二级缓存 -->\n	<cache type=\"org.mybatis.caches.ehcache.LoggingEhcache\"/>\n\n#end\n#if(${baseResultMap})\n	<!-- 通用查询映射结果 -->\n	<resultMap id=\"BaseResultMap\" type=\"${package.Entity}.${entity}\">\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})##生成主键排在第一位\n		<id column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n#foreach($field in ${table.fields})\n#if(!${field.keyFlag})##生成普通字段\n		<result column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n	</resultMap>\n\n#end\n#if(${baseColumnList})\n    <!-- 通用查询结果列 -->\n    <sql id=\"Base_Column_List\">\n        ${table.fieldNames}\n    </sql>\n\n#end\n\n    <select id=\"select${entity}s\" resultMap=\"BaseResultMap\">\n        SELECT\n             *\n        FROM ${table.name}\n        WHERE\n             1 = 1\n        <if test=\"filter.id!=null and filter.id!=\'\'\">\n            AND	${entity}_ID= #{filter.id}\n        </if>\n        ORDER BY ${entity}_ID DESC\n    </select>\n\n</mapper>\n', '2020-06-28 16:26:35', '2020-06-28 16:26:35');
INSERT INTO `t_code_project_template` VALUES ('55', '4', '27', '.java', 'package ${package.Mapper};\n\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${superMapperClassPackage};\nimport com.baomidou.mybatisplus.plugins.pagination.Pagination;\nimport org.apache.ibatis.annotations.Param;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} Mapper 接口 </p>\n *\n * @author : zhengqing\n * @date : ${date}\n */\npublic interface ${table.mapperName} extends ${superMapperClass}<${entity}> {\n\n    /**\n     * 列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(Pagination page, @Param(\"filter\") ${formQueryPara} filter);\n\n    /**\n     * 列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(@Param(\"filter\") ${formQueryPara} filter);\n}', '2020-06-28 16:26:35', '2020-06-28 16:26:35');

-- ----------------------------
-- Table structure for t_code_project_velocity_context
-- ----------------------------
DROP TABLE IF EXISTS `t_code_project_velocity_context`;
CREATE TABLE `t_code_project_velocity_context` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `velocity` varchar(100) DEFAULT NULL COMMENT '模板数据',
  `context` text COMMENT '内容',
  `project_id` int(11) DEFAULT NULL COMMENT '所属项目',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1224 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='代码生成器 - 项目 - 模板数据源';

-- ----------------------------
-- Records of t_code_project_velocity_context
-- ----------------------------
INSERT INTO `t_code_project_velocity_context` VALUES ('854', 'date', '\"2020-06-28 17:48:26\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('855', 'superControllerClassPackage', 'null', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('856', 'superServiceImplClassPackage', '\"com.baomidou.mybatisplus.service.impl.ServiceImpl\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('857', 'baseResultMap', 'true', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('858', 'vue', '\"com.codestrike.user.vue\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('859', 'service.impl', '\"com.codestrike.user.service.impl\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('860', 'moduleName', 'null', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('861', 'js', '\"com.codestrike.user.js\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('862', 'mapper', '\"com.codestrike.user.mapper\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('863', 'superMapperClass', '\"BaseMapper\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('864', 'mapper.xml', '\"com.codestrike.user.mapper.xml\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('865', 'superControllerClass', 'null', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('866', 'entityPropertyName', '\"city\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('867', 'activeRecord', 'true', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('868', 'superServiceClass', '\"IService\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('869', 'api', '\"com.codestrike.user.api\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('870', 'superServiceImplClass', '\"ServiceImpl\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('871', 'table', '{\"comment\":\"\",\"commonFields\":[],\"convert\":true,\"entityName\":\"City\",\"entityPath\":\"city\",\"fieldNames\":\"ID AS id, Name AS Name, CountryCode AS CountryCode, District AS District, Population AS Population\",\"fields\":[{\"capitalName\":\"Id\",\"columnType\":\"INTEGER\",\"comment\":\"试试\",\"convert\":true,\"keyFlag\":true,\"keyIdentityFlag\":true,\"name\":\"ID\",\"propertyName\":\"id\",\"propertyType\":\"Integer\",\"type\":\"int(11)\"},{\"capitalName\":\"Name\",\"columnType\":\"STRING\",\"comment\":\"试试2\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"Name\",\"propertyName\":\"Name\",\"propertyType\":\"String\",\"type\":\"char(35)\"},{\"capitalName\":\"CountryCode\",\"columnType\":\"STRING\",\"comment\":\"试试3\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"CountryCode\",\"propertyName\":\"CountryCode\",\"propertyType\":\"String\",\"type\":\"char(3)\"},{\"capitalName\":\"District\",\"columnType\":\"STRING\",\"comment\":\"试试4\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"District\",\"propertyName\":\"District\",\"propertyType\":\"String\",\"type\":\"char(20)\"},{\"capitalName\":\"Population\",\"columnType\":\"INTEGER\",\"comment\":\"试试5\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"Population\",\"propertyName\":\"Population\",\"propertyType\":\"Integer\",\"type\":\"int(11)\"}],\"importPackages\":[\"com.baomidou.mybatisplus.enums.IdType\",\"com.baomidou.mybatisplus.annotations.TableId\",\"com.baomidou.mybatisplus.annotations.TableField\",\"com.baomidou.mybatisplus.enums.IdType\",\"com.baomidou.mybatisplus.activerecord.Model\",\"com.baomidou.mybatisplus.annotations.TableName\",\"java.io.Serializable\"],\"name\":\"city\",\"packageInfo\":{\"input\":\"CityInput\",\"service\":\"CityService\",\"vue\":\"CityVue\",\"service.impl\":\"CityServiceImpl\",\"js\":\"CityJs\",\"mapper\":\"CityMapper\",\"api\":\"CityApi\",\"mapper.xml\":\"CityMapperXml\",\"entity\":\"CityEntity\"}}', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('872', 'package', '{\"input\":\"com.codestrike.user.dto.input\",\"service\":\"com.codestrike.user.service\",\"vue\":\"com.codestrike.user.vue\",\"service.impl\":\"com.codestrike.user.service.impl\",\"js\":\"com.codestrike.user.js\",\"mapper\":\"com.codestrike.user.mapper\",\"api\":\"com.codestrike.user.api\",\"mapper.xml\":\"com.codestrike.user.mapper.xml\",\"entity\":\"com.codestrike.user.entity\"}', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('873', 'queryFields', '[]', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('874', 'author', '\"zhengqing\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('875', 'baseColumnList', 'false', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('876', 'tableInfo', '{\"input\":\"CityInput\",\"service\":\"CityService\",\"vue\":\"CityVue\",\"service.impl\":\"CityServiceImpl\",\"js\":\"CityJs\",\"mapper\":\"CityMapper\",\"api\":\"CityApi\",\"mapper.xml\":\"CityMapperXml\",\"entity\":\"CityEntity\"}', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('877', 'superMapperClassPackage', '\"com.baomidou.mybatisplus.mapper.BaseMapper\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('878', 'input', '\"com.codestrike.user.dto.input\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('879', 'entityBuilderModel', 'false', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('880', 'superServiceClassPackage', '\"com.baomidou.mybatisplus.service.IService\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('881', 'service', '\"com.codestrike.user.service\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('882', 'entityColumnConstant', 'false', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('883', 'enableCache', 'false', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('884', 'entity', '\"City\"', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('885', 'superEntityClass', 'null', '1', '2020-06-28 17:48:27', '2020-06-28 17:48:27');
INSERT INTO `t_code_project_velocity_context` VALUES ('1198', 'date', '\"2020-06-28 18:36:48\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1199', 'superControllerClassPackage', 'null', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1200', 'superServiceImplClassPackage', '\"com.baomidou.mybatisplus.service.impl.ServiceImpl\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1201', 'baseResultMap', 'true', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1202', 'moduleName', 'null', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1203', 'mapper', '\"com.test.mapper\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1204', 'superMapperClass', '\"BaseMapper\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1205', 'mapper.xml', '\"com.test.mapper.xml\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1206', 'superControllerClass', 'null', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1207', 'entityPropertyName', '\"city\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1208', 'activeRecord', 'true', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1209', 'superServiceClass', '\"IService\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1210', 'superServiceImplClass', '\"ServiceImpl\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1211', 'table', '{\"comment\":\"\",\"commonFields\":[],\"convert\":true,\"entityName\":\"City\",\"entityPath\":\"city\",\"fieldNames\":\"ID AS id, Name AS Name, CountryCode AS CountryCode, District AS District, Population AS Population\",\"fields\":[{\"capitalName\":\"Id\",\"columnType\":\"INTEGER\",\"comment\":\"试试\",\"convert\":true,\"keyFlag\":true,\"keyIdentityFlag\":true,\"name\":\"ID\",\"propertyName\":\"id\",\"propertyType\":\"Integer\",\"type\":\"int(11)\"},{\"capitalName\":\"Name\",\"columnType\":\"STRING\",\"comment\":\"试试2\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"Name\",\"propertyName\":\"Name\",\"propertyType\":\"String\",\"type\":\"char(35)\"},{\"capitalName\":\"CountryCode\",\"columnType\":\"STRING\",\"comment\":\"试试3\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"CountryCode\",\"propertyName\":\"CountryCode\",\"propertyType\":\"String\",\"type\":\"char(3)\"},{\"capitalName\":\"District\",\"columnType\":\"STRING\",\"comment\":\"试试4\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"District\",\"propertyName\":\"District\",\"propertyType\":\"String\",\"type\":\"char(20)\"},{\"capitalName\":\"Population\",\"columnType\":\"INTEGER\",\"comment\":\"试试5\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"Population\",\"propertyName\":\"Population\",\"propertyType\":\"Integer\",\"type\":\"int(11)\"}],\"importPackages\":[\"com.baomidou.mybatisplus.enums.IdType\",\"com.baomidou.mybatisplus.annotations.TableId\",\"com.baomidou.mybatisplus.annotations.TableField\",\"com.baomidou.mybatisplus.enums.IdType\",\"com.baomidou.mybatisplus.activerecord.Model\",\"com.baomidou.mybatisplus.annotations.TableName\",\"java.io.Serializable\"],\"name\":\"city\",\"packageInfo\":{\"mapper\":\"CityMapper\",\"mapper.xml\":\"CityMapperXml\"}}', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1212', 'package', '{\"mapper\":\"com.test.mapper\",\"mapper.xml\":\"com.test.mapper.xml\"}', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1213', 'queryFields', '[]', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1214', 'author', '\"自动生成\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1215', 'baseColumnList', 'false', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1216', 'tableInfo', '{\"mapper\":\"CityMapper\",\"mapper.xml\":\"CityMapperXml\"}', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1217', 'superMapperClassPackage', '\"com.baomidou.mybatisplus.mapper.BaseMapper\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1218', 'entityBuilderModel', 'false', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1219', 'superServiceClassPackage', '\"com.baomidou.mybatisplus.service.IService\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1220', 'entityColumnConstant', 'false', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1221', 'enableCache', 'false', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1222', 'entity', '\"City\"', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');
INSERT INTO `t_code_project_velocity_context` VALUES ('1223', 'superEntityClass', 'null', '4', '2020-06-28 18:36:49', '2020-06-28 18:36:49');

-- ----------------------------
-- Table structure for t_code_table_config
-- ----------------------------
DROP TABLE IF EXISTS `t_code_table_config`;
CREATE TABLE `t_code_table_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` int(11) DEFAULT NULL COMMENT '项目ID',
  `table_name` varchar(255) DEFAULT NULL COMMENT '表名',
  `query_columns` varchar(1024) DEFAULT NULL COMMENT '用于检索字段',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目数据表配置表';

-- ----------------------------
-- Records of t_code_table_config
-- ----------------------------

-- ----------------------------
-- Table structure for t_sys_log
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_log`;
CREATE TABLE `t_sys_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) DEFAULT NULL COMMENT '接口名称',
  `url` varchar(255) DEFAULT NULL COMMENT '接口地址',
  `ip` varchar(30) DEFAULT NULL COMMENT '访问人IP',
  `user_id` int(11) DEFAULT '0' COMMENT '访问人ID 0:未登录用户操作',
  `status` int(2) DEFAULT '1' COMMENT '访问状态',
  `execute_time` varchar(10) DEFAULT NULL COMMENT '接口执行时间',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2245 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='系统管理 - 日志表';

-- ----------------------------
-- Records of t_sys_log
-- ----------------------------
INSERT INTO `t_sys_log` VALUES ('1702', '登录系统', 'http://127.0.0.1:9100/api/auth/login', '127.0.0.1', '1', '200', '1216 ms', '2020-06-27 17:41:41', '2020-06-27 17:41:41');
INSERT INTO `t_sys_log` VALUES ('1703', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '811 ms', '2020-06-27 17:41:43', '2020-06-27 17:41:43');
INSERT INTO `t_sys_log` VALUES ('1704', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '1000 ms', '2020-06-27 17:42:23', '2020-06-27 17:42:23');
INSERT INTO `t_sys_log` VALUES ('1705', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '45 ms', '2020-06-27 17:42:33', '2020-06-27 17:42:33');
INSERT INTO `t_sys_log` VALUES ('1706', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '17 ms', '2020-06-27 17:43:13', '2020-06-27 17:43:13');
INSERT INTO `t_sys_log` VALUES ('1707', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '86 ms', '2020-06-27 17:43:13', '2020-06-27 17:43:13');
INSERT INTO `t_sys_log` VALUES ('1708', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '6 ms', '2020-06-27 17:43:22', '2020-06-27 17:43:22');
INSERT INTO `t_sys_log` VALUES ('1709', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '44 ms', '2020-06-27 17:43:22', '2020-06-27 17:43:22');
INSERT INTO `t_sys_log` VALUES ('1710', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '111 ms', '2020-06-27 17:43:33', '2020-06-27 17:43:33');
INSERT INTO `t_sys_log` VALUES ('1711', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-06-27 17:43:39', '2020-06-27 17:43:39');
INSERT INTO `t_sys_log` VALUES ('1712', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '73 ms', '2020-06-27 17:43:39', '2020-06-27 17:43:39');
INSERT INTO `t_sys_log` VALUES ('1713', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin;JSESSIONID=code-generator_token_3fff059f-fe0d-41e3-af3e-93a0be8f86c2', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 17:50:24', '2020-06-27 17:50:24');
INSERT INTO `t_sys_log` VALUES ('1714', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 17:50:24', '2020-06-27 17:50:24');
INSERT INTO `t_sys_log` VALUES ('1715', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 17:50:48', '2020-06-27 17:50:48');
INSERT INTO `t_sys_log` VALUES ('1716', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 17:50:48', '2020-06-27 17:50:48');
INSERT INTO `t_sys_log` VALUES ('1717', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 17:51:30', '2020-06-27 17:51:30');
INSERT INTO `t_sys_log` VALUES ('1718', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '22 ms', '2020-06-27 17:52:19', '2020-06-27 17:52:19');
INSERT INTO `t_sys_log` VALUES ('1719', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '41 ms', '2020-06-27 17:52:23', '2020-06-27 17:52:23');
INSERT INTO `t_sys_log` VALUES ('1720', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '6 ms', '2020-06-27 17:52:27', '2020-06-27 17:52:27');
INSERT INTO `t_sys_log` VALUES ('1721', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '38 ms', '2020-06-27 17:52:27', '2020-06-27 17:52:27');
INSERT INTO `t_sys_log` VALUES ('1722', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '144 ms', '2020-06-27 17:52:53', '2020-06-27 17:52:53');
INSERT INTO `t_sys_log` VALUES ('1723', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '29 ms', '2020-06-27 17:52:53', '2020-06-27 17:52:53');
INSERT INTO `t_sys_log` VALUES ('1724', '获取项目代码模板对应数据源模板列表', 'http://127.0.0.1:9100/api/code/project_template/listPageCodeProjectVelocityContext', '127.0.0.1', '1', '200', '28 ms', '2020-06-27 17:52:56', '2020-06-27 17:52:56');
INSERT INTO `t_sys_log` VALUES ('1725', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '12 ms', '2020-06-27 17:53:07', '2020-06-27 17:53:07');
INSERT INTO `t_sys_log` VALUES ('1726', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '37 ms', '2020-06-27 17:53:07', '2020-06-27 17:53:07');
INSERT INTO `t_sys_log` VALUES ('1727', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '9 ms', '2020-06-27 17:53:54', '2020-06-27 17:53:54');
INSERT INTO `t_sys_log` VALUES ('1728', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '28 ms', '2020-06-27 17:53:54', '2020-06-27 17:53:54');
INSERT INTO `t_sys_log` VALUES ('1729', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '17 ms', '2020-06-27 17:53:54', '2020-06-27 17:53:54');
INSERT INTO `t_sys_log` VALUES ('1730', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '28 ms', '2020-06-27 17:53:55', '2020-06-27 17:53:55');
INSERT INTO `t_sys_log` VALUES ('1731', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '29 ms', '2020-06-27 17:53:57', '2020-06-27 17:53:57');
INSERT INTO `t_sys_log` VALUES ('1732', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '49 ms', '2020-06-27 17:54:01', '2020-06-27 17:54:01');
INSERT INTO `t_sys_log` VALUES ('1733', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '19 ms', '2020-06-27 17:54:05', '2020-06-27 17:54:05');
INSERT INTO `t_sys_log` VALUES ('1734', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '25 ms', '2020-06-27 17:54:09', '2020-06-27 17:54:09');
INSERT INTO `t_sys_log` VALUES ('1735', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '14 ms', '2020-06-27 17:54:21', '2020-06-27 17:54:21');
INSERT INTO `t_sys_log` VALUES ('1736', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-27 17:54:44', '2020-06-27 17:54:44');
INSERT INTO `t_sys_log` VALUES ('1737', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-27 17:54:47', '2020-06-27 17:54:47');
INSERT INTO `t_sys_log` VALUES ('1738', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-06-27 17:54:52', '2020-06-27 17:54:52');
INSERT INTO `t_sys_log` VALUES ('1739', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '12 ms', '2020-06-27 17:54:52', '2020-06-27 17:54:52');
INSERT INTO `t_sys_log` VALUES ('1740', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '7 ms', '2020-06-27 17:55:11', '2020-06-27 17:55:11');
INSERT INTO `t_sys_log` VALUES ('1741', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '39 ms', '2020-06-27 17:55:11', '2020-06-27 17:55:11');
INSERT INTO `t_sys_log` VALUES ('1742', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '14 ms', '2020-06-27 17:55:15', '2020-06-27 17:55:15');
INSERT INTO `t_sys_log` VALUES ('1743', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '32 ms', '2020-06-27 17:55:32', '2020-06-27 17:55:32');
INSERT INTO `t_sys_log` VALUES ('1744', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-27 17:55:39', '2020-06-27 17:55:39');
INSERT INTO `t_sys_log` VALUES ('1745', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '21 ms', '2020-06-27 17:55:39', '2020-06-27 17:55:39');
INSERT INTO `t_sys_log` VALUES ('1746', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '13 ms', '2020-06-27 17:56:14', '2020-06-27 17:56:14');
INSERT INTO `t_sys_log` VALUES ('1747', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '24 ms', '2020-06-27 17:56:14', '2020-06-27 17:56:14');
INSERT INTO `t_sys_log` VALUES ('1748', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '24 ms', '2020-06-27 17:56:23', '2020-06-27 17:56:23');
INSERT INTO `t_sys_log` VALUES ('1749', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '16 ms', '2020-06-27 17:56:23', '2020-06-27 17:56:23');
INSERT INTO `t_sys_log` VALUES ('1750', '保存数据库信息表', 'http://127.0.0.1:9100/api/code/database/save', '127.0.0.1', '1', '200', '45 ms', '2020-06-27 17:58:10', '2020-06-27 17:58:10');
INSERT INTO `t_sys_log` VALUES ('1751', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-27 17:58:10', '2020-06-27 17:58:10');
INSERT INTO `t_sys_log` VALUES ('1752', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '30 ms', '2020-06-27 17:58:12', '2020-06-27 17:58:12');
INSERT INTO `t_sys_log` VALUES ('1753', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '10 ms', '2020-06-27 17:58:13', '2020-06-27 17:58:13');
INSERT INTO `t_sys_log` VALUES ('1754', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '83 ms', '2020-06-27 17:58:17', '2020-06-27 17:58:17');
INSERT INTO `t_sys_log` VALUES ('1755', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '151 ms', '2020-06-27 17:58:20', '2020-06-27 17:58:20');
INSERT INTO `t_sys_log` VALUES ('1756', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '283 ms', '2020-06-27 18:04:11', '2020-06-27 18:04:11');
INSERT INTO `t_sys_log` VALUES ('1757', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '138 ms', '2020-06-27 18:04:12', '2020-06-27 18:04:12');
INSERT INTO `t_sys_log` VALUES ('1758', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '1015 ms', '2020-06-27 18:04:17', '2020-06-27 18:04:17');
INSERT INTO `t_sys_log` VALUES ('1759', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '32 ms', '2020-06-27 18:04:17', '2020-06-27 18:04:17');
INSERT INTO `t_sys_log` VALUES ('1760', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '29 ms', '2020-06-27 18:04:39', '2020-06-27 18:04:39');
INSERT INTO `t_sys_log` VALUES ('1761', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '72 ms', '2020-06-27 18:04:40', '2020-06-27 18:04:40');
INSERT INTO `t_sys_log` VALUES ('1762', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '606 ms', '2020-06-27 18:04:46', '2020-06-27 18:04:46');
INSERT INTO `t_sys_log` VALUES ('1763', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-06-27 18:04:47', '2020-06-27 18:04:47');
INSERT INTO `t_sys_log` VALUES ('1764', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '18 ms', '2020-06-27 18:05:05', '2020-06-27 18:05:05');
INSERT INTO `t_sys_log` VALUES ('1765', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '58 ms', '2020-06-27 18:05:06', '2020-06-27 18:05:06');
INSERT INTO `t_sys_log` VALUES ('1766', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '17357 ms', '2020-06-27 18:05:24', '2020-06-27 18:05:24');
INSERT INTO `t_sys_log` VALUES ('1767', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '3658 ms', '2020-06-27 18:07:15', '2020-06-27 18:07:15');
INSERT INTO `t_sys_log` VALUES ('1768', '登录系统', 'http://127.0.0.1:9100/api/auth/login', '127.0.0.1', '1', '200', '278 ms', '2020-06-27 18:08:27', '2020-06-27 18:08:27');
INSERT INTO `t_sys_log` VALUES ('1769', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '186 ms', '2020-06-27 18:08:28', '2020-06-27 18:08:28');
INSERT INTO `t_sys_log` VALUES ('1770', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '136 ms', '2020-06-27 18:08:32', '2020-06-27 18:08:32');
INSERT INTO `t_sys_log` VALUES ('1771', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '256 ms', '2020-06-27 18:08:32', '2020-06-27 18:08:32');
INSERT INTO `t_sys_log` VALUES ('1772', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '73 ms', '2020-06-27 18:08:36', '2020-06-27 18:08:36');
INSERT INTO `t_sys_log` VALUES ('1773', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '180 ms', '2020-06-27 18:08:39', '2020-06-27 18:08:39');
INSERT INTO `t_sys_log` VALUES ('1774', '保存表字段信息', 'http://127.0.0.1:9100/api/code/database/saveTable', '127.0.0.1', '1', '200', '161 ms', '2020-06-27 18:08:41', '2020-06-27 18:08:41');
INSERT INTO `t_sys_log` VALUES ('1775', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '127 ms', '2020-06-27 18:08:41', '2020-06-27 18:08:41');
INSERT INTO `t_sys_log` VALUES ('1776', '保存表字段信息', 'http://127.0.0.1:9100/api/code/database/saveTable', '127.0.0.1', '1', '200', '374 ms', '2020-06-27 18:08:56', '2020-06-27 18:08:56');
INSERT INTO `t_sys_log` VALUES ('1777', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '108 ms', '2020-06-27 18:08:56', '2020-06-27 18:08:56');
INSERT INTO `t_sys_log` VALUES ('1778', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '161 ms', '2020-06-27 18:08:57', '2020-06-27 18:08:57');
INSERT INTO `t_sys_log` VALUES ('1779', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '1047 ms', '2020-06-27 18:09:07', '2020-06-27 18:09:07');
INSERT INTO `t_sys_log` VALUES ('1780', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '24 ms', '2020-06-27 18:09:08', '2020-06-27 18:09:08');
INSERT INTO `t_sys_log` VALUES ('1781', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '24 ms', '2020-06-27 18:09:18', '2020-06-27 18:09:18');
INSERT INTO `t_sys_log` VALUES ('1782', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '66 ms', '2020-06-27 18:09:18', '2020-06-27 18:09:18');
INSERT INTO `t_sys_log` VALUES ('1783', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '15556 ms', '2020-06-27 18:09:44', '2020-06-27 18:09:44');
INSERT INTO `t_sys_log` VALUES ('1784', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '4136 ms', '2020-06-27 18:13:26', '2020-06-27 18:13:26');
INSERT INTO `t_sys_log` VALUES ('1785', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '126 ms', '2020-06-27 18:13:26', '2020-06-27 18:13:26');
INSERT INTO `t_sys_log` VALUES ('1786', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '40 ms', '2020-06-27 18:13:43', '2020-06-27 18:13:43');
INSERT INTO `t_sys_log` VALUES ('1787', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '66 ms', '2020-06-27 18:13:44', '2020-06-27 18:13:44');
INSERT INTO `t_sys_log` VALUES ('1788', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '10217 ms', '2020-06-27 18:13:55', '2020-06-27 18:13:55');
INSERT INTO `t_sys_log` VALUES ('1789', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '31963 ms', '2020-06-27 18:14:30', '2020-06-27 18:14:30');
INSERT INTO `t_sys_log` VALUES ('1790', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '21712 ms', '2020-06-27 18:14:54', '2020-06-27 18:14:54');
INSERT INTO `t_sys_log` VALUES ('1791', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin;JSESSIONID=code-generator_token_79a85257-623d-462e-adab-b9d386f0834e', '127.0.0.1', '0', '401', '19 ms', '2020-06-27 18:32:17', '2020-06-27 18:32:17');
INSERT INTO `t_sys_log` VALUES ('1792', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '303 ms', '2020-06-27 18:37:11', '2020-06-27 18:37:11');
INSERT INTO `t_sys_log` VALUES ('1793', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '102 ms', '2020-06-27 18:37:11', '2020-06-27 18:37:11');
INSERT INTO `t_sys_log` VALUES ('1794', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '336 ms', '2020-06-27 18:43:44', '2020-06-27 18:43:44');
INSERT INTO `t_sys_log` VALUES ('1795', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '266 ms', '2020-06-27 18:45:02', '2020-06-27 18:45:02');
INSERT INTO `t_sys_log` VALUES ('1796', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '162 ms', '2020-06-27 18:45:02', '2020-06-27 18:45:02');
INSERT INTO `t_sys_log` VALUES ('1797', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '37 ms', '2020-06-27 18:45:30', '2020-06-27 18:45:30');
INSERT INTO `t_sys_log` VALUES ('1798', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '276 ms', '2020-06-27 18:45:31', '2020-06-27 18:45:31');
INSERT INTO `t_sys_log` VALUES ('1799', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '37 ms', '2020-06-27 18:46:04', '2020-06-27 18:46:04');
INSERT INTO `t_sys_log` VALUES ('1800', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '73 ms', '2020-06-27 18:46:05', '2020-06-27 18:46:05');
INSERT INTO `t_sys_log` VALUES ('1801', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '9 ms', '2020-06-27 18:46:08', '2020-06-27 18:46:08');
INSERT INTO `t_sys_log` VALUES ('1802', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:46:08', '2020-06-27 18:46:08');
INSERT INTO `t_sys_log` VALUES ('1803', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:46:19', '2020-06-27 18:46:19');
INSERT INTO `t_sys_log` VALUES ('1804', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:46:19', '2020-06-27 18:46:19');
INSERT INTO `t_sys_log` VALUES ('1805', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:47:54', '2020-06-27 18:47:54');
INSERT INTO `t_sys_log` VALUES ('1806', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:47:54', '2020-06-27 18:47:54');
INSERT INTO `t_sys_log` VALUES ('1807', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:47:59', '2020-06-27 18:47:59');
INSERT INTO `t_sys_log` VALUES ('1808', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:48:00', '2020-06-27 18:48:00');
INSERT INTO `t_sys_log` VALUES ('1809', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:48:06', '2020-06-27 18:48:06');
INSERT INTO `t_sys_log` VALUES ('1810', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:48:06', '2020-06-27 18:48:06');
INSERT INTO `t_sys_log` VALUES ('1811', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:49:24', '2020-06-27 18:49:24');
INSERT INTO `t_sys_log` VALUES ('1812', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:49:25', '2020-06-27 18:49:25');
INSERT INTO `t_sys_log` VALUES ('1813', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '17 ms', '2020-06-27 18:49:26', '2020-06-27 18:49:26');
INSERT INTO `t_sys_log` VALUES ('1814', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '126 ms', '2020-06-27 18:49:31', '2020-06-27 18:49:31');
INSERT INTO `t_sys_log` VALUES ('1815', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:49:33', '2020-06-27 18:49:33');
INSERT INTO `t_sys_log` VALUES ('1816', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:49:33', '2020-06-27 18:49:33');
INSERT INTO `t_sys_log` VALUES ('1817', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:49:44', '2020-06-27 18:49:44');
INSERT INTO `t_sys_log` VALUES ('1818', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:49:44', '2020-06-27 18:49:44');
INSERT INTO `t_sys_log` VALUES ('1819', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:49:53', '2020-06-27 18:49:53');
INSERT INTO `t_sys_log` VALUES ('1820', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:49:53', '2020-06-27 18:49:53');
INSERT INTO `t_sys_log` VALUES ('1821', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:50:11', '2020-06-27 18:50:11');
INSERT INTO `t_sys_log` VALUES ('1822', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:50:11', '2020-06-27 18:50:11');
INSERT INTO `t_sys_log` VALUES ('1823', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:50:14', '2020-06-27 18:50:14');
INSERT INTO `t_sys_log` VALUES ('1824', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:50:14', '2020-06-27 18:50:14');
INSERT INTO `t_sys_log` VALUES ('1825', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '7 ms', '2020-06-27 18:53:55', '2020-06-27 18:53:55');
INSERT INTO `t_sys_log` VALUES ('1826', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:53:55', '2020-06-27 18:53:55');
INSERT INTO `t_sys_log` VALUES ('1827', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:54:01', '2020-06-27 18:54:01');
INSERT INTO `t_sys_log` VALUES ('1828', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:54:01', '2020-06-27 18:54:01');
INSERT INTO `t_sys_log` VALUES ('1829', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:54:13', '2020-06-27 18:54:13');
INSERT INTO `t_sys_log` VALUES ('1830', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:54:13', '2020-06-27 18:54:13');
INSERT INTO `t_sys_log` VALUES ('1831', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '176 ms', '2020-06-27 18:56:01', '2020-06-27 18:56:01');
INSERT INTO `t_sys_log` VALUES ('1832', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '259 ms', '2020-06-27 18:56:07', '2020-06-27 18:56:07');
INSERT INTO `t_sys_log` VALUES ('1833', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:56:10', '2020-06-27 18:56:10');
INSERT INTO `t_sys_log` VALUES ('1834', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '0 ms', '2020-06-27 18:56:10', '2020-06-27 18:56:10');
INSERT INTO `t_sys_log` VALUES ('1835', '登录系统', 'http://127.0.0.1:9100/api/auth/login', '127.0.0.1', '1', '200', '308 ms', '2020-06-28 14:44:27', '2020-06-28 14:44:27');
INSERT INTO `t_sys_log` VALUES ('1836', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '412 ms', '2020-06-28 14:44:28', '2020-06-28 14:44:28');
INSERT INTO `t_sys_log` VALUES ('1837', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9100/api/system/user/listPage', '127.0.0.1', '1', '200', '297 ms', '2020-06-28 14:44:33', '2020-06-28 14:44:33');
INSERT INTO `t_sys_log` VALUES ('1838', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9100/api/system/role/listPage', '127.0.0.1', '1', '200', '185 ms', '2020-06-28 14:44:40', '2020-06-28 14:44:40');
INSERT INTO `t_sys_log` VALUES ('1839', '获取菜单树', 'http://127.0.0.1:9100/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '64 ms', '2020-06-28 14:44:44', '2020-06-28 14:44:44');
INSERT INTO `t_sys_log` VALUES ('1840', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9100/api/system/role/listPage', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 14:45:01', '2020-06-28 14:45:01');
INSERT INTO `t_sys_log` VALUES ('1841', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9100/api/system/user/listPage', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 14:45:09', '2020-06-28 14:45:09');
INSERT INTO `t_sys_log` VALUES ('1842', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9100/api/system/role/listPage', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 14:45:22', '2020-06-28 14:45:22');
INSERT INTO `t_sys_log` VALUES ('1843', '获取角色信息', 'http://127.0.0.1:9100/api/system/role/detail', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 14:45:25', '2020-06-28 14:45:25');
INSERT INTO `t_sys_log` VALUES ('1844', '获取用户树', 'http://127.0.0.1:9100/api/system/user/treeUser', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 14:45:26', '2020-06-28 14:45:26');
INSERT INTO `t_sys_log` VALUES ('1845', '获取菜单树', 'http://127.0.0.1:9100/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 14:45:26', '2020-06-28 14:45:26');
INSERT INTO `t_sys_log` VALUES ('1846', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9100/api/system/userRole/list', '127.0.0.1', '1', '200', '58 ms', '2020-06-28 14:45:26', '2020-06-28 14:45:26');
INSERT INTO `t_sys_log` VALUES ('1847', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9100/api/system/roleMenu/list', '127.0.0.1', '1', '200', '105 ms', '2020-06-28 14:45:26', '2020-06-28 14:45:26');
INSERT INTO `t_sys_log` VALUES ('1848', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9100/api/system/role/listPage', '127.0.0.1', '1', '200', '43 ms', '2020-06-28 14:45:27', '2020-06-28 14:45:27');
INSERT INTO `t_sys_log` VALUES ('1849', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9100/api/system/userRole/list', '127.0.0.1', '1', '200', '5 ms', '2020-06-28 14:45:32', '2020-06-28 14:45:32');
INSERT INTO `t_sys_log` VALUES ('1850', '获取菜单树', 'http://127.0.0.1:9100/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 14:45:32', '2020-06-28 14:45:32');
INSERT INTO `t_sys_log` VALUES ('1851', '获取角色信息', 'http://127.0.0.1:9100/api/system/role/detail', '127.0.0.1', '1', '200', '68 ms', '2020-06-28 14:45:32', '2020-06-28 14:45:32');
INSERT INTO `t_sys_log` VALUES ('1852', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9100/api/system/roleMenu/list', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 14:45:32', '2020-06-28 14:45:32');
INSERT INTO `t_sys_log` VALUES ('1853', '获取用户树', 'http://127.0.0.1:9100/api/system/user/treeUser', '127.0.0.1', '1', '200', '50 ms', '2020-06-28 14:45:32', '2020-06-28 14:45:32');
INSERT INTO `t_sys_log` VALUES ('1854', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9100/api/system/role/listPage', '127.0.0.1', '1', '200', '44 ms', '2020-06-28 14:45:38', '2020-06-28 14:45:38');
INSERT INTO `t_sys_log` VALUES ('1855', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9100/api/system/userRole/list', '127.0.0.1', '1', '200', '5 ms', '2020-06-28 14:45:40', '2020-06-28 14:45:40');
INSERT INTO `t_sys_log` VALUES ('1856', '获取用户树', 'http://127.0.0.1:9100/api/system/user/treeUser', '127.0.0.1', '1', '200', '6 ms', '2020-06-28 14:45:41', '2020-06-28 14:45:41');
INSERT INTO `t_sys_log` VALUES ('1857', '获取角色信息', 'http://127.0.0.1:9100/api/system/role/detail', '127.0.0.1', '1', '200', '2 ms', '2020-06-28 14:45:40', '2020-06-28 14:45:40');
INSERT INTO `t_sys_log` VALUES ('1858', '获取菜单树', 'http://127.0.0.1:9100/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '24 ms', '2020-06-28 14:45:41', '2020-06-28 14:45:41');
INSERT INTO `t_sys_log` VALUES ('1859', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9100/api/system/roleMenu/list', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 14:45:41', '2020-06-28 14:45:41');
INSERT INTO `t_sys_log` VALUES ('1860', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9100/api/system/role/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 14:45:45', '2020-06-28 14:45:45');
INSERT INTO `t_sys_log` VALUES ('1861', '获取角色信息', 'http://127.0.0.1:9100/api/system/role/detail', '127.0.0.1', '1', '200', '3 ms', '2020-06-28 14:45:48', '2020-06-28 14:45:48');
INSERT INTO `t_sys_log` VALUES ('1862', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9100/api/system/roleMenu/list', '127.0.0.1', '1', '200', '8 ms', '2020-06-28 14:45:48', '2020-06-28 14:45:48');
INSERT INTO `t_sys_log` VALUES ('1863', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9100/api/system/userRole/list', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 14:45:48', '2020-06-28 14:45:48');
INSERT INTO `t_sys_log` VALUES ('1864', '获取用户树', 'http://127.0.0.1:9100/api/system/user/treeUser', '127.0.0.1', '1', '200', '2 ms', '2020-06-28 14:45:48', '2020-06-28 14:45:48');
INSERT INTO `t_sys_log` VALUES ('1865', '获取菜单树', 'http://127.0.0.1:9100/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 14:45:48', '2020-06-28 14:45:48');
INSERT INTO `t_sys_log` VALUES ('1866', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9100/api/system/log/listPage', '127.0.0.1', '1', '200', '50 ms', '2020-06-28 14:45:53', '2020-06-28 14:45:53');
INSERT INTO `t_sys_log` VALUES ('1867', '退出系统', 'http://127.0.0.1:9100/api/auth/logout', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 14:45:57', '2020-06-28 14:45:57');
INSERT INTO `t_sys_log` VALUES ('1868', '登录系统', 'http://127.0.0.1:9100/api/auth/login', '127.0.0.1', '2', '200', '37 ms', '2020-06-28 14:46:01', '2020-06-28 14:46:01');
INSERT INTO `t_sys_log` VALUES ('1869', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '2', '200', '24 ms', '2020-06-28 14:46:01', '2020-06-28 14:46:01');
INSERT INTO `t_sys_log` VALUES ('1870', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '2', '200', '27 ms', '2020-06-28 14:49:17', '2020-06-28 14:49:17');
INSERT INTO `t_sys_log` VALUES ('1871', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '2', '200', '109 ms', '2020-06-28 15:03:42', '2020-06-28 15:03:42');
INSERT INTO `t_sys_log` VALUES ('1872', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '2', '200', '220 ms', '2020-06-28 15:13:41', '2020-06-28 15:13:41');
INSERT INTO `t_sys_log` VALUES ('1873', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '2', '200', '311 ms', '2020-06-28 15:22:45', '2020-06-28 15:22:45');
INSERT INTO `t_sys_log` VALUES ('1874', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '2', '200', '212 ms', '2020-06-28 15:43:42', '2020-06-28 15:43:42');
INSERT INTO `t_sys_log` VALUES ('1875', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '2', '200', '7791 ms', '2020-06-28 15:43:50', '2020-06-28 15:43:50');
INSERT INTO `t_sys_log` VALUES ('1876', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '2', '200', '258 ms', '2020-06-28 15:44:17', '2020-06-28 15:44:17');
INSERT INTO `t_sys_log` VALUES ('1877', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '2', '200', '163 ms', '2020-06-28 15:44:21', '2020-06-28 15:44:21');
INSERT INTO `t_sys_log` VALUES ('1878', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '2', '200', '14 ms', '2020-06-28 15:44:24', '2020-06-28 15:44:24');
INSERT INTO `t_sys_log` VALUES ('1879', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '2', '200', '96 ms', '2020-06-28 15:44:24', '2020-06-28 15:44:24');
INSERT INTO `t_sys_log` VALUES ('1880', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '2', '200', '42 ms', '2020-06-28 15:44:27', '2020-06-28 15:44:27');
INSERT INTO `t_sys_log` VALUES ('1881', '退出系统', 'http://127.0.0.1:9100/api/auth/logout', '127.0.0.1', '2', '200', '20 ms', '2020-06-28 15:44:42', '2020-06-28 15:44:42');
INSERT INTO `t_sys_log` VALUES ('1882', '登录系统', 'http://127.0.0.1:9100/api/auth/login', '127.0.0.1', '1', '200', '143 ms', '2020-06-28 15:44:45', '2020-06-28 15:44:45');
INSERT INTO `t_sys_log` VALUES ('1883', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '53 ms', '2020-06-28 15:44:45', '2020-06-28 15:44:45');
INSERT INTO `t_sys_log` VALUES ('1884', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '10408 ms', '2020-06-28 15:44:56', '2020-06-28 15:44:56');
INSERT INTO `t_sys_log` VALUES ('1885', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '46 ms', '2020-06-28 15:45:02', '2020-06-28 15:45:02');
INSERT INTO `t_sys_log` VALUES ('1886', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '1968 ms', '2020-06-28 15:45:04', '2020-06-28 15:45:04');
INSERT INTO `t_sys_log` VALUES ('1887', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '39 ms', '2020-06-28 15:45:09', '2020-06-28 15:45:09');
INSERT INTO `t_sys_log` VALUES ('1888', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 15:45:31', '2020-06-28 15:45:31');
INSERT INTO `t_sys_log` VALUES ('1889', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 15:45:35', '2020-06-28 15:45:35');
INSERT INTO `t_sys_log` VALUES ('1890', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '52 ms', '2020-06-28 15:45:35', '2020-06-28 15:45:35');
INSERT INTO `t_sys_log` VALUES ('1891', '获取项目代码模板对应数据源模板列表', 'http://127.0.0.1:9100/api/code/project_template/listPageCodeProjectVelocityContext', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 15:45:47', '2020-06-28 15:45:47');
INSERT INTO `t_sys_log` VALUES ('1892', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '33 ms', '2020-06-28 15:45:54', '2020-06-28 15:45:54');
INSERT INTO `t_sys_log` VALUES ('1893', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 15:45:57', '2020-06-28 15:45:57');
INSERT INTO `t_sys_log` VALUES ('1894', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9100/api/system/user/listPage', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 15:46:07', '2020-06-28 15:46:07');
INSERT INTO `t_sys_log` VALUES ('1895', '保存系统管理-用户基础信息表', 'http://127.0.0.1:9100/api/system/user/save', '127.0.0.1', '1', '200', '19 ms', '2020-06-28 15:46:18', '2020-06-28 15:46:18');
INSERT INTO `t_sys_log` VALUES ('1896', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9100/api/system/user/listPage', '127.0.0.1', '1', '200', '52 ms', '2020-06-28 15:46:18', '2020-06-28 15:46:18');
INSERT INTO `t_sys_log` VALUES ('1897', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9100/api/system/role/listPage', '127.0.0.1', '1', '200', '131 ms', '2020-06-28 15:46:20', '2020-06-28 15:46:20');
INSERT INTO `t_sys_log` VALUES ('1898', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9100/api/system/log/listPage', '127.0.0.1', '1', '200', '39 ms', '2020-06-28 15:46:23', '2020-06-28 15:46:23');
INSERT INTO `t_sys_log` VALUES ('1899', '获取菜单树', 'http://127.0.0.1:9100/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '131 ms', '2020-06-28 15:46:29', '2020-06-28 15:46:29');
INSERT INTO `t_sys_log` VALUES ('1900', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '51 ms', '2020-06-28 15:49:32', '2020-06-28 15:49:32');
INSERT INTO `t_sys_log` VALUES ('1901', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '45 ms', '2020-06-28 15:49:35', '2020-06-28 15:49:35');
INSERT INTO `t_sys_log` VALUES ('1902', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '10 ms', '2020-06-28 15:49:37', '2020-06-28 15:49:37');
INSERT INTO `t_sys_log` VALUES ('1903', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '45 ms', '2020-06-28 15:49:37', '2020-06-28 15:49:37');
INSERT INTO `t_sys_log` VALUES ('1904', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '8 ms', '2020-06-28 15:49:37', '2020-06-28 15:49:37');
INSERT INTO `t_sys_log` VALUES ('1905', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '44 ms', '2020-06-28 15:49:37', '2020-06-28 15:49:37');
INSERT INTO `t_sys_log` VALUES ('1906', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '82 ms', '2020-06-28 15:49:46', '2020-06-28 15:49:46');
INSERT INTO `t_sys_log` VALUES ('1907', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '90 ms', '2020-06-28 15:49:48', '2020-06-28 15:49:48');
INSERT INTO `t_sys_log` VALUES ('1908', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '1405 ms', '2020-06-28 15:49:57', '2020-06-28 15:49:57');
INSERT INTO `t_sys_log` VALUES ('1909', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 15:49:57', '2020-06-28 15:49:57');
INSERT INTO `t_sys_log` VALUES ('1910', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '44 ms', '2020-06-28 15:49:58', '2020-06-28 15:49:58');
INSERT INTO `t_sys_log` VALUES ('1911', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '623 ms', '2020-06-28 15:50:01', '2020-06-28 15:50:01');
INSERT INTO `t_sys_log` VALUES ('1912', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '59 ms', '2020-06-28 15:50:02', '2020-06-28 15:50:02');
INSERT INTO `t_sys_log` VALUES ('1913', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '81 ms', '2020-06-28 15:50:02', '2020-06-28 15:50:02');
INSERT INTO `t_sys_log` VALUES ('1914', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 15:51:02', '2020-06-28 15:51:02');
INSERT INTO `t_sys_log` VALUES ('1915', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 15:51:06', '2020-06-28 15:51:06');
INSERT INTO `t_sys_log` VALUES ('1916', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '38 ms', '2020-06-28 15:51:12', '2020-06-28 15:51:12');
INSERT INTO `t_sys_log` VALUES ('1917', '保存项目代码模板表', 'http://127.0.0.1:9100/api/code/bsTemplate/save', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 15:51:43', '2020-06-28 15:51:43');
INSERT INTO `t_sys_log` VALUES ('1918', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 15:51:44', '2020-06-28 15:51:44');
INSERT INTO `t_sys_log` VALUES ('1919', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '28 ms', '2020-06-28 15:52:14', '2020-06-28 15:52:14');
INSERT INTO `t_sys_log` VALUES ('1920', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 15:52:18', '2020-06-28 15:52:18');
INSERT INTO `t_sys_log` VALUES ('1921', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 15:52:21', '2020-06-28 15:52:21');
INSERT INTO `t_sys_log` VALUES ('1922', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 15:52:34', '2020-06-28 15:52:34');
INSERT INTO `t_sys_log` VALUES ('1923', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '6 ms', '2020-06-28 15:52:34', '2020-06-28 15:52:34');
INSERT INTO `t_sys_log` VALUES ('1924', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 15:52:53', '2020-06-28 15:52:53');
INSERT INTO `t_sys_log` VALUES ('1925', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '18 ms', '2020-06-28 15:52:58', '2020-06-28 15:52:58');
INSERT INTO `t_sys_log` VALUES ('1926', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '14 ms', '2020-06-28 15:53:01', '2020-06-28 15:53:01');
INSERT INTO `t_sys_log` VALUES ('1927', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '47 ms', '2020-06-28 15:53:01', '2020-06-28 15:53:01');
INSERT INTO `t_sys_log` VALUES ('1928', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 15:53:05', '2020-06-28 15:53:05');
INSERT INTO `t_sys_log` VALUES ('1929', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '8 ms', '2020-06-28 15:53:09', '2020-06-28 15:53:09');
INSERT INTO `t_sys_log` VALUES ('1930', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 15:53:09', '2020-06-28 15:53:09');
INSERT INTO `t_sys_log` VALUES ('1931', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '10 ms', '2020-06-28 15:53:12', '2020-06-28 15:53:12');
INSERT INTO `t_sys_log` VALUES ('1932', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 15:53:12', '2020-06-28 15:53:12');
INSERT INTO `t_sys_log` VALUES ('1933', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 15:53:13', '2020-06-28 15:53:13');
INSERT INTO `t_sys_log` VALUES ('1934', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 15:53:13', '2020-06-28 15:53:13');
INSERT INTO `t_sys_log` VALUES ('1935', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '21 ms', '2020-06-28 15:53:17', '2020-06-28 15:53:17');
INSERT INTO `t_sys_log` VALUES ('1936', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '18 ms', '2020-06-28 15:53:40', '2020-06-28 15:53:40');
INSERT INTO `t_sys_log` VALUES ('1937', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '13 ms', '2020-06-28 15:55:15', '2020-06-28 15:55:15');
INSERT INTO `t_sys_log` VALUES ('1938', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 15:55:15', '2020-06-28 15:55:15');
INSERT INTO `t_sys_log` VALUES ('1939', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '13 ms', '2020-06-28 15:55:20', '2020-06-28 15:55:20');
INSERT INTO `t_sys_log` VALUES ('1940', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 15:55:52', '2020-06-28 15:55:52');
INSERT INTO `t_sys_log` VALUES ('1941', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 15:57:10', '2020-06-28 15:57:10');
INSERT INTO `t_sys_log` VALUES ('1942', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '13 ms', '2020-06-28 15:57:28', '2020-06-28 15:57:28');
INSERT INTO `t_sys_log` VALUES ('1943', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 15:57:31', '2020-06-28 15:57:31');
INSERT INTO `t_sys_log` VALUES ('1944', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 15:57:43', '2020-06-28 15:57:43');
INSERT INTO `t_sys_log` VALUES ('1945', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '36 ms', '2020-06-28 15:57:44', '2020-06-28 15:57:44');
INSERT INTO `t_sys_log` VALUES ('1946', '保存或更新代码生成器 - 项目管理', 'http://127.0.0.1:9100/api/code/project/saveOrUpdateProject', '127.0.0.1', '1', '200', '38 ms', '2020-06-28 15:57:50', '2020-06-28 15:57:50');
INSERT INTO `t_sys_log` VALUES ('1947', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 15:57:50', '2020-06-28 15:57:50');
INSERT INTO `t_sys_log` VALUES ('1948', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 15:57:56', '2020-06-28 15:57:56');
INSERT INTO `t_sys_log` VALUES ('1949', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '29 ms', '2020-06-28 15:57:57', '2020-06-28 15:57:57');
INSERT INTO `t_sys_log` VALUES ('1950', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '25 ms', '2020-06-28 15:57:57', '2020-06-28 15:57:57');
INSERT INTO `t_sys_log` VALUES ('1951', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '19 ms', '2020-06-28 15:58:04', '2020-06-28 15:58:04');
INSERT INTO `t_sys_log` VALUES ('1952', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 15:58:07', '2020-06-28 15:58:07');
INSERT INTO `t_sys_log` VALUES ('1953', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '37 ms', '2020-06-28 15:58:12', '2020-06-28 15:58:12');
INSERT INTO `t_sys_log` VALUES ('1954', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 15:58:19', '2020-06-28 15:58:19');
INSERT INTO `t_sys_log` VALUES ('1955', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 15:58:22', '2020-06-28 15:58:22');
INSERT INTO `t_sys_log` VALUES ('1956', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '35 ms', '2020-06-28 15:58:22', '2020-06-28 15:58:22');
INSERT INTO `t_sys_log` VALUES ('1957', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 15:58:24', '2020-06-28 15:58:24');
INSERT INTO `t_sys_log` VALUES ('1958', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '14 ms', '2020-06-28 15:58:26', '2020-06-28 15:58:26');
INSERT INTO `t_sys_log` VALUES ('1959', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '46 ms', '2020-06-28 15:58:26', '2020-06-28 15:58:26');
INSERT INTO `t_sys_log` VALUES ('1960', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '25 ms', '2020-06-28 15:58:29', '2020-06-28 15:58:29');
INSERT INTO `t_sys_log` VALUES ('1961', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '10 ms', '2020-06-28 15:58:33', '2020-06-28 15:58:33');
INSERT INTO `t_sys_log` VALUES ('1962', '获取项目代码模板对应数据源模板列表', 'http://127.0.0.1:9100/api/code/project_template/listPageCodeProjectVelocityContext', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 15:58:43', '2020-06-28 15:58:43');
INSERT INTO `t_sys_log` VALUES ('1963', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '91 ms', '2020-06-28 15:58:48', '2020-06-28 15:58:48');
INSERT INTO `t_sys_log` VALUES ('1964', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 15:58:48', '2020-06-28 15:58:48');
INSERT INTO `t_sys_log` VALUES ('1965', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '25 ms', '2020-06-28 15:58:50', '2020-06-28 15:58:50');
INSERT INTO `t_sys_log` VALUES ('1966', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '21 ms', '2020-06-28 15:58:51', '2020-06-28 15:58:51');
INSERT INTO `t_sys_log` VALUES ('1967', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 15:58:55', '2020-06-28 15:58:55');
INSERT INTO `t_sys_log` VALUES ('1968', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '8 ms', '2020-06-28 15:58:56', '2020-06-28 15:58:56');
INSERT INTO `t_sys_log` VALUES ('1969', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '33 ms', '2020-06-28 15:58:56', '2020-06-28 15:58:56');
INSERT INTO `t_sys_log` VALUES ('1970', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 15:58:57', '2020-06-28 15:58:57');
INSERT INTO `t_sys_log` VALUES ('1971', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '21 ms', '2020-06-28 15:59:00', '2020-06-28 15:59:00');
INSERT INTO `t_sys_log` VALUES ('1972', '获取项目代码模板对应数据源模板列表', 'http://127.0.0.1:9100/api/code/project_template/listPageCodeProjectVelocityContext', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 15:59:09', '2020-06-28 15:59:09');
INSERT INTO `t_sys_log` VALUES ('1973', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 15:59:12', '2020-06-28 15:59:12');
INSERT INTO `t_sys_log` VALUES ('1974', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 15:59:16', '2020-06-28 15:59:16');
INSERT INTO `t_sys_log` VALUES ('1975', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 15:59:16', '2020-06-28 15:59:16');
INSERT INTO `t_sys_log` VALUES ('1976', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '6 ms', '2020-06-28 15:59:17', '2020-06-28 15:59:17');
INSERT INTO `t_sys_log` VALUES ('1977', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 15:59:17', '2020-06-28 15:59:17');
INSERT INTO `t_sys_log` VALUES ('1978', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 15:59:26', '2020-06-28 15:59:26');
INSERT INTO `t_sys_log` VALUES ('1979', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '7 ms', '2020-06-28 15:59:29', '2020-06-28 15:59:29');
INSERT INTO `t_sys_log` VALUES ('1980', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 15:59:32', '2020-06-28 15:59:32');
INSERT INTO `t_sys_log` VALUES ('1981', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 15:59:37', '2020-06-28 15:59:37');
INSERT INTO `t_sys_log` VALUES ('1982', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '8 ms', '2020-06-28 15:59:47', '2020-06-28 15:59:47');
INSERT INTO `t_sys_log` VALUES ('1983', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '4 ms', '2020-06-28 15:59:49', '2020-06-28 15:59:49');
INSERT INTO `t_sys_log` VALUES ('1984', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 15:59:52', '2020-06-28 15:59:52');
INSERT INTO `t_sys_log` VALUES ('1985', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '33 ms', '2020-06-28 16:02:39', '2020-06-28 16:02:39');
INSERT INTO `t_sys_log` VALUES ('1986', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 16:03:11', '2020-06-28 16:03:11');
INSERT INTO `t_sys_log` VALUES ('1987', '登录系统', 'http://127.0.0.1:9100/api/auth/login', '127.0.0.1', '1', '200', '367 ms', '2020-06-28 16:07:28', '2020-06-28 16:07:28');
INSERT INTO `t_sys_log` VALUES ('1988', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '326 ms', '2020-06-28 16:07:28', '2020-06-28 16:07:28');
INSERT INTO `t_sys_log` VALUES ('1989', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '327 ms', '2020-06-28 16:07:33', '2020-06-28 16:07:33');
INSERT INTO `t_sys_log` VALUES ('1990', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '6906 ms', '2020-06-28 16:07:36', '2020-06-28 16:07:36');
INSERT INTO `t_sys_log` VALUES ('1991', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '110 ms', '2020-06-28 16:07:39', '2020-06-28 16:07:39');
INSERT INTO `t_sys_log` VALUES ('1992', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '24 ms', '2020-06-28 16:07:41', '2020-06-28 16:07:41');
INSERT INTO `t_sys_log` VALUES ('1993', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '114 ms', '2020-06-28 16:07:41', '2020-06-28 16:07:41');
INSERT INTO `t_sys_log` VALUES ('1994', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '77 ms', '2020-06-28 16:07:46', '2020-06-28 16:07:46');
INSERT INTO `t_sys_log` VALUES ('1995', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '18 ms', '2020-06-28 16:07:46', '2020-06-28 16:07:46');
INSERT INTO `t_sys_log` VALUES ('1996', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:07:47', '2020-06-28 16:07:47');
INSERT INTO `t_sys_log` VALUES ('1997', '删除代码生成器 - 项目管理', 'http://127.0.0.1:9100/api/code/project/deleteProject', '127.0.0.1', '1', '200', '96 ms', '2020-06-28 16:07:50', '2020-06-28 16:07:50');
INSERT INTO `t_sys_log` VALUES ('1998', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '42 ms', '2020-06-28 16:07:50', '2020-06-28 16:07:50');
INSERT INTO `t_sys_log` VALUES ('1999', '保存或更新代码生成器 - 项目管理', 'http://127.0.0.1:9100/api/code/project/saveOrUpdateProject', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 16:07:58', '2020-06-28 16:07:58');
INSERT INTO `t_sys_log` VALUES ('2000', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:07:58', '2020-06-28 16:07:58');
INSERT INTO `t_sys_log` VALUES ('2001', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '13 ms', '2020-06-28 16:08:00', '2020-06-28 16:08:00');
INSERT INTO `t_sys_log` VALUES ('2002', '删除代码生成器 - 项目管理', 'http://127.0.0.1:9100/api/code/project/deleteProject', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 16:08:22', '2020-06-28 16:08:22');
INSERT INTO `t_sys_log` VALUES ('2003', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 16:08:23', '2020-06-28 16:08:23');
INSERT INTO `t_sys_log` VALUES ('2004', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '60 ms', '2020-06-28 16:09:49', '2020-06-28 16:09:49');
INSERT INTO `t_sys_log` VALUES ('2005', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 16:09:50', '2020-06-28 16:09:50');
INSERT INTO `t_sys_log` VALUES ('2006', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '211 ms', '2020-06-28 16:14:42', '2020-06-28 16:14:42');
INSERT INTO `t_sys_log` VALUES ('2007', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '139 ms', '2020-06-28 16:14:43', '2020-06-28 16:14:43');
INSERT INTO `t_sys_log` VALUES ('2008', '保存或更新代码生成器 - 项目管理', 'http://127.0.0.1:9100/api/code/project/saveOrUpdateProject', '127.0.0.1', '1', '200', '50 ms', '2020-06-28 16:14:53', '2020-06-28 16:14:53');
INSERT INTO `t_sys_log` VALUES ('2009', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '57 ms', '2020-06-28 16:14:53', '2020-06-28 16:14:53');
INSERT INTO `t_sys_log` VALUES ('2010', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '13 ms', '2020-06-28 16:14:55', '2020-06-28 16:14:55');
INSERT INTO `t_sys_log` VALUES ('2011', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 16:15:00', '2020-06-28 16:15:00');
INSERT INTO `t_sys_log` VALUES ('2012', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 16:15:03', '2020-06-28 16:15:03');
INSERT INTO `t_sys_log` VALUES ('2013', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '14 ms', '2020-06-28 16:15:07', '2020-06-28 16:15:07');
INSERT INTO `t_sys_log` VALUES ('2014', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 16:15:10', '2020-06-28 16:15:10');
INSERT INTO `t_sys_log` VALUES ('2015', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '95 ms', '2020-06-28 16:15:18', '2020-06-28 16:15:18');
INSERT INTO `t_sys_log` VALUES ('2016', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '39 ms', '2020-06-28 16:15:22', '2020-06-28 16:15:22');
INSERT INTO `t_sys_log` VALUES ('2017', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 16:15:23', '2020-06-28 16:15:23');
INSERT INTO `t_sys_log` VALUES ('2018', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 16:15:27', '2020-06-28 16:15:27');
INSERT INTO `t_sys_log` VALUES ('2019', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 16:15:27', '2020-06-28 16:15:27');
INSERT INTO `t_sys_log` VALUES ('2020', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '19 ms', '2020-06-28 16:15:31', '2020-06-28 16:15:31');
INSERT INTO `t_sys_log` VALUES ('2021', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '118 ms', '2020-06-28 16:15:31', '2020-06-28 16:15:31');
INSERT INTO `t_sys_log` VALUES ('2022', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '330 ms', '2020-06-28 16:15:37', '2020-06-28 16:15:37');
INSERT INTO `t_sys_log` VALUES ('2023', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '44 ms', '2020-06-28 16:15:37', '2020-06-28 16:15:37');
INSERT INTO `t_sys_log` VALUES ('2024', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '19 ms', '2020-06-28 16:15:40', '2020-06-28 16:15:40');
INSERT INTO `t_sys_log` VALUES ('2025', '删除项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/delete', '127.0.0.1', '1', '200', '25 ms', '2020-06-28 16:15:44', '2020-06-28 16:15:44');
INSERT INTO `t_sys_log` VALUES ('2026', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 16:15:44', '2020-06-28 16:15:44');
INSERT INTO `t_sys_log` VALUES ('2027', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '18 ms', '2020-06-28 16:15:45', '2020-06-28 16:15:45');
INSERT INTO `t_sys_log` VALUES ('2028', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 16:15:47', '2020-06-28 16:15:47');
INSERT INTO `t_sys_log` VALUES ('2029', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 16:15:49', '2020-06-28 16:15:49');
INSERT INTO `t_sys_log` VALUES ('2030', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 16:15:56', '2020-06-28 16:15:56');
INSERT INTO `t_sys_log` VALUES ('2031', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 16:15:57', '2020-06-28 16:15:57');
INSERT INTO `t_sys_log` VALUES ('2032', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '46 ms', '2020-06-28 16:16:00', '2020-06-28 16:16:00');
INSERT INTO `t_sys_log` VALUES ('2033', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 16:16:00', '2020-06-28 16:16:00');
INSERT INTO `t_sys_log` VALUES ('2034', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '32 ms', '2020-06-28 16:16:05', '2020-06-28 16:16:05');
INSERT INTO `t_sys_log` VALUES ('2035', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '10 ms', '2020-06-28 16:16:05', '2020-06-28 16:16:05');
INSERT INTO `t_sys_log` VALUES ('2036', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '7 ms', '2020-06-28 16:16:07', '2020-06-28 16:16:07');
INSERT INTO `t_sys_log` VALUES ('2037', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 16:16:10', '2020-06-28 16:16:10');
INSERT INTO `t_sys_log` VALUES ('2038', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 16:16:13', '2020-06-28 16:16:13');
INSERT INTO `t_sys_log` VALUES ('2039', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '77 ms', '2020-06-28 16:16:13', '2020-06-28 16:16:13');
INSERT INTO `t_sys_log` VALUES ('2040', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '32 ms', '2020-06-28 16:18:43', '2020-06-28 16:18:43');
INSERT INTO `t_sys_log` VALUES ('2041', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '37 ms', '2020-06-28 16:18:46', '2020-06-28 16:18:46');
INSERT INTO `t_sys_log` VALUES ('2042', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '24 ms', '2020-06-28 16:18:46', '2020-06-28 16:18:46');
INSERT INTO `t_sys_log` VALUES ('2043', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '63 ms', '2020-06-28 16:18:48', '2020-06-28 16:18:48');
INSERT INTO `t_sys_log` VALUES ('2044', '获取项目代码模板对应数据源模板列表', 'http://127.0.0.1:9100/api/code/project_template/listPageCodeProjectVelocityContext', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 16:18:50', '2020-06-28 16:18:50');
INSERT INTO `t_sys_log` VALUES ('2045', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 16:18:52', '2020-06-28 16:18:52');
INSERT INTO `t_sys_log` VALUES ('2046', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 16:18:54', '2020-06-28 16:18:54');
INSERT INTO `t_sys_log` VALUES ('2047', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '7 ms', '2020-06-28 16:18:55', '2020-06-28 16:18:55');
INSERT INTO `t_sys_log` VALUES ('2048', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 16:18:59', '2020-06-28 16:18:59');
INSERT INTO `t_sys_log` VALUES ('2049', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 16:18:59', '2020-06-28 16:18:59');
INSERT INTO `t_sys_log` VALUES ('2050', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 16:19:00', '2020-06-28 16:19:00');
INSERT INTO `t_sys_log` VALUES ('2051', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 16:19:04', '2020-06-28 16:19:04');
INSERT INTO `t_sys_log` VALUES ('2052', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 16:19:04', '2020-06-28 16:19:04');
INSERT INTO `t_sys_log` VALUES ('2053', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 16:19:05', '2020-06-28 16:19:05');
INSERT INTO `t_sys_log` VALUES ('2054', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 16:19:09', '2020-06-28 16:19:09');
INSERT INTO `t_sys_log` VALUES ('2055', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '59 ms', '2020-06-28 16:19:09', '2020-06-28 16:19:09');
INSERT INTO `t_sys_log` VALUES ('2056', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 16:19:11', '2020-06-28 16:19:11');
INSERT INTO `t_sys_log` VALUES ('2057', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 16:19:13', '2020-06-28 16:19:13');
INSERT INTO `t_sys_log` VALUES ('2058', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 16:19:15', '2020-06-28 16:19:15');
INSERT INTO `t_sys_log` VALUES ('2059', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 16:20:12', '2020-06-28 16:20:12');
INSERT INTO `t_sys_log` VALUES ('2060', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 16:20:57', '2020-06-28 16:20:57');
INSERT INTO `t_sys_log` VALUES ('2061', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:21:20', '2020-06-28 16:21:20');
INSERT INTO `t_sys_log` VALUES ('2062', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 16:22:26', '2020-06-28 16:22:26');
INSERT INTO `t_sys_log` VALUES ('2063', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '28 ms', '2020-06-28 16:22:29', '2020-06-28 16:22:29');
INSERT INTO `t_sys_log` VALUES ('2064', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 16:22:51', '2020-06-28 16:22:51');
INSERT INTO `t_sys_log` VALUES ('2065', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 16:23:00', '2020-06-28 16:23:00');
INSERT INTO `t_sys_log` VALUES ('2066', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '51 ms', '2020-06-28 16:23:00', '2020-06-28 16:23:00');
INSERT INTO `t_sys_log` VALUES ('2067', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '8302 ms', '2020-06-28 16:23:02', '2020-06-28 16:23:02');
INSERT INTO `t_sys_log` VALUES ('2068', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 16:23:04', '2020-06-28 16:23:04');
INSERT INTO `t_sys_log` VALUES ('2069', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '36 ms', '2020-06-28 16:23:07', '2020-06-28 16:23:07');
INSERT INTO `t_sys_log` VALUES ('2070', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '55 ms', '2020-06-28 16:23:07', '2020-06-28 16:23:07');
INSERT INTO `t_sys_log` VALUES ('2071', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 16:23:12', '2020-06-28 16:23:12');
INSERT INTO `t_sys_log` VALUES ('2072', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 16:23:16', '2020-06-28 16:23:16');
INSERT INTO `t_sys_log` VALUES ('2073', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 16:23:18', '2020-06-28 16:23:18');
INSERT INTO `t_sys_log` VALUES ('2074', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 16:23:30', '2020-06-28 16:23:30');
INSERT INTO `t_sys_log` VALUES ('2075', '删除代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/deletePackage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 16:23:35', '2020-06-28 16:23:35');
INSERT INTO `t_sys_log` VALUES ('2076', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '11 ms', '2020-06-28 16:23:35', '2020-06-28 16:23:35');
INSERT INTO `t_sys_log` VALUES ('2077', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 16:23:38', '2020-06-28 16:23:38');
INSERT INTO `t_sys_log` VALUES ('2078', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:23:48', '2020-06-28 16:23:48');
INSERT INTO `t_sys_log` VALUES ('2079', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 16:23:48', '2020-06-28 16:23:48');
INSERT INTO `t_sys_log` VALUES ('2080', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:23:51', '2020-06-28 16:23:51');
INSERT INTO `t_sys_log` VALUES ('2081', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:23:55', '2020-06-28 16:23:55');
INSERT INTO `t_sys_log` VALUES ('2082', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '36 ms', '2020-06-28 16:23:55', '2020-06-28 16:23:55');
INSERT INTO `t_sys_log` VALUES ('2083', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 16:23:57', '2020-06-28 16:23:57');
INSERT INTO `t_sys_log` VALUES ('2084', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '33 ms', '2020-06-28 16:23:59', '2020-06-28 16:23:59');
INSERT INTO `t_sys_log` VALUES ('2085', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '40 ms', '2020-06-28 16:23:59', '2020-06-28 16:23:59');
INSERT INTO `t_sys_log` VALUES ('2086', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '32 ms', '2020-06-28 16:24:04', '2020-06-28 16:24:04');
INSERT INTO `t_sys_log` VALUES ('2087', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '57 ms', '2020-06-28 16:24:04', '2020-06-28 16:24:04');
INSERT INTO `t_sys_log` VALUES ('2088', '删除项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/delete', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 16:24:06', '2020-06-28 16:24:06');
INSERT INTO `t_sys_log` VALUES ('2089', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '21 ms', '2020-06-28 16:24:06', '2020-06-28 16:24:06');
INSERT INTO `t_sys_log` VALUES ('2090', '删除项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/delete', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 16:24:08', '2020-06-28 16:24:08');
INSERT INTO `t_sys_log` VALUES ('2091', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '43 ms', '2020-06-28 16:24:08', '2020-06-28 16:24:08');
INSERT INTO `t_sys_log` VALUES ('2092', '删除项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/delete', '127.0.0.1', '1', '200', '24 ms', '2020-06-28 16:24:10', '2020-06-28 16:24:10');
INSERT INTO `t_sys_log` VALUES ('2093', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 16:24:10', '2020-06-28 16:24:10');
INSERT INTO `t_sys_log` VALUES ('2094', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '28 ms', '2020-06-28 16:24:11', '2020-06-28 16:24:11');
INSERT INTO `t_sys_log` VALUES ('2095', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:24:13', '2020-06-28 16:24:13');
INSERT INTO `t_sys_log` VALUES ('2096', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 16:24:19', '2020-06-28 16:24:19');
INSERT INTO `t_sys_log` VALUES ('2097', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '56 ms', '2020-06-28 16:24:19', '2020-06-28 16:24:19');
INSERT INTO `t_sys_log` VALUES ('2098', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '25 ms', '2020-06-28 16:24:23', '2020-06-28 16:24:23');
INSERT INTO `t_sys_log` VALUES ('2099', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 16:24:24', '2020-06-28 16:24:24');
INSERT INTO `t_sys_log` VALUES ('2100', '获取项目包类型列表', 'http://127.0.0.1:9100/api/code/project/listPackage', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 16:24:26', '2020-06-28 16:24:26');
INSERT INTO `t_sys_log` VALUES ('2101', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9100/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 16:24:29', '2020-06-28 16:24:29');
INSERT INTO `t_sys_log` VALUES ('2102', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '13 ms', '2020-06-28 16:24:30', '2020-06-28 16:24:30');
INSERT INTO `t_sys_log` VALUES ('2103', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '6 ms', '2020-06-28 16:24:33', '2020-06-28 16:24:33');
INSERT INTO `t_sys_log` VALUES ('2104', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 16:24:33', '2020-06-28 16:24:33');
INSERT INTO `t_sys_log` VALUES ('2105', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:24:38', '2020-06-28 16:24:38');
INSERT INTO `t_sys_log` VALUES ('2106', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '39 ms', '2020-06-28 16:24:40', '2020-06-28 16:24:40');
INSERT INTO `t_sys_log` VALUES ('2107', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '29 ms', '2020-06-28 16:24:40', '2020-06-28 16:24:40');
INSERT INTO `t_sys_log` VALUES ('2108', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 16:25:29', '2020-06-28 16:25:29');
INSERT INTO `t_sys_log` VALUES ('2109', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 16:25:40', '2020-06-28 16:25:40');
INSERT INTO `t_sys_log` VALUES ('2110', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 16:25:42', '2020-06-28 16:25:42');
INSERT INTO `t_sys_log` VALUES ('2111', '保存项目代码模板表', 'http://127.0.0.1:9100/api/code/bsTemplate/save', '127.0.0.1', '1', '200', '25 ms', '2020-06-28 16:25:50', '2020-06-28 16:25:50');
INSERT INTO `t_sys_log` VALUES ('2112', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '33 ms', '2020-06-28 16:25:50', '2020-06-28 16:25:50');
INSERT INTO `t_sys_log` VALUES ('2113', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 16:25:55', '2020-06-28 16:25:55');
INSERT INTO `t_sys_log` VALUES ('2114', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '39 ms', '2020-06-28 16:25:55', '2020-06-28 16:25:55');
INSERT INTO `t_sys_log` VALUES ('2115', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '14 ms', '2020-06-28 16:26:04', '2020-06-28 16:26:04');
INSERT INTO `t_sys_log` VALUES ('2116', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '54 ms', '2020-06-28 16:26:17', '2020-06-28 16:26:17');
INSERT INTO `t_sys_log` VALUES ('2117', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 16:26:17', '2020-06-28 16:26:17');
INSERT INTO `t_sys_log` VALUES ('2118', '删除项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/delete', '127.0.0.1', '1', '200', '31 ms', '2020-06-28 16:26:23', '2020-06-28 16:26:23');
INSERT INTO `t_sys_log` VALUES ('2119', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '29 ms', '2020-06-28 16:26:23', '2020-06-28 16:26:23');
INSERT INTO `t_sys_log` VALUES ('2120', '删除项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/delete', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 16:26:25', '2020-06-28 16:26:25');
INSERT INTO `t_sys_log` VALUES ('2121', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '28 ms', '2020-06-28 16:26:25', '2020-06-28 16:26:25');
INSERT INTO `t_sys_log` VALUES ('2122', '删除项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/delete', '127.0.0.1', '1', '200', '24 ms', '2020-06-28 16:26:26', '2020-06-28 16:26:26');
INSERT INTO `t_sys_log` VALUES ('2123', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 16:26:27', '2020-06-28 16:26:27');
INSERT INTO `t_sys_log` VALUES ('2124', '生成项目代码模板', 'http://127.0.0.1:9100/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '83 ms', '2020-06-28 16:26:35', '2020-06-28 16:26:35');
INSERT INTO `t_sys_log` VALUES ('2125', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 16:26:35', '2020-06-28 16:26:35');
INSERT INTO `t_sys_log` VALUES ('2126', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '567 ms', '2020-06-28 16:31:05', '2020-06-28 16:31:05');
INSERT INTO `t_sys_log` VALUES ('2127', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 16:31:08', '2020-06-28 16:31:08');
INSERT INTO `t_sys_log` VALUES ('2128', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '19 ms', '2020-06-28 16:31:15', '2020-06-28 16:31:15');
INSERT INTO `t_sys_log` VALUES ('2129', '获取项目包架构树', 'http://127.0.0.1:9100/api/code/project/tree', '127.0.0.1', '1', '200', '15 ms', '2020-06-28 16:31:21', '2020-06-28 16:31:21');
INSERT INTO `t_sys_log` VALUES ('2130', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '88 ms', '2020-06-28 16:31:30', '2020-06-28 16:31:30');
INSERT INTO `t_sys_log` VALUES ('2131', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 16:33:59', '2020-06-28 16:33:59');
INSERT INTO `t_sys_log` VALUES ('2132', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '85 ms', '2020-06-28 16:33:59', '2020-06-28 16:33:59');
INSERT INTO `t_sys_log` VALUES ('2133', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 16:34:01', '2020-06-28 16:34:01');
INSERT INTO `t_sys_log` VALUES ('2134', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '82 ms', '2020-06-28 16:34:01', '2020-06-28 16:34:01');
INSERT INTO `t_sys_log` VALUES ('2135', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '104 ms', '2020-06-28 16:34:04', '2020-06-28 16:34:04');
INSERT INTO `t_sys_log` VALUES ('2136', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '154 ms', '2020-06-28 16:34:06', '2020-06-28 16:34:06');
INSERT INTO `t_sys_log` VALUES ('2137', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin;JSESSIONID=code-generator_token_a65f36b5-30db-476a-8da5-8df6c0614338', '127.0.0.1', '1', '401', '13 ms', '2020-06-28 17:30:23', '2020-06-28 17:30:23');
INSERT INTO `t_sys_log` VALUES ('2138', '登录系统', 'http://127.0.0.1:9100/api/auth/login', '127.0.0.1', '1', '200', '242 ms', '2020-06-28 17:30:27', '2020-06-28 17:30:27');
INSERT INTO `t_sys_log` VALUES ('2139', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '393 ms', '2020-06-28 17:30:27', '2020-06-28 17:30:27');
INSERT INTO `t_sys_log` VALUES ('2140', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '8361 ms', '2020-06-28 17:30:36', '2020-06-28 17:30:36');
INSERT INTO `t_sys_log` VALUES ('2141', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '53 ms', '2020-06-28 17:30:41', '2020-06-28 17:30:41');
INSERT INTO `t_sys_log` VALUES ('2142', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '2080 ms', '2020-06-28 17:30:44', '2020-06-28 17:30:44');
INSERT INTO `t_sys_log` VALUES ('2143', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '1850 ms', '2020-06-28 17:30:48', '2020-06-28 17:30:48');
INSERT INTO `t_sys_log` VALUES ('2144', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '1813 ms', '2020-06-28 17:30:53', '2020-06-28 17:30:53');
INSERT INTO `t_sys_log` VALUES ('2145', '获取服务器信息', 'http://127.0.0.1:9100/api/server', '127.0.0.1', '1', '200', '2255 ms', '2020-06-28 17:30:56', '2020-06-28 17:30:56');
INSERT INTO `t_sys_log` VALUES ('2146', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '39 ms', '2020-06-28 17:30:57', '2020-06-28 17:30:57');
INSERT INTO `t_sys_log` VALUES ('2147', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 17:31:00', '2020-06-28 17:31:00');
INSERT INTO `t_sys_log` VALUES ('2148', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 17:31:30', '2020-06-28 17:31:30');
INSERT INTO `t_sys_log` VALUES ('2149', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '14 ms', '2020-06-28 17:31:42', '2020-06-28 17:31:42');
INSERT INTO `t_sys_log` VALUES ('2150', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '58 ms', '2020-06-28 17:31:42', '2020-06-28 17:31:42');
INSERT INTO `t_sys_log` VALUES ('2151', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 17:31:45', '2020-06-28 17:31:45');
INSERT INTO `t_sys_log` VALUES ('2152', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '80 ms', '2020-06-28 17:31:48', '2020-06-28 17:31:48');
INSERT INTO `t_sys_log` VALUES ('2153', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9100/api/code/project/listPage', '127.0.0.1', '1', '200', '24 ms', '2020-06-28 17:31:55', '2020-06-28 17:31:55');
INSERT INTO `t_sys_log` VALUES ('2154', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '29 ms', '2020-06-28 17:31:57', '2020-06-28 17:31:57');
INSERT INTO `t_sys_log` VALUES ('2155', '保存项目代码模板表', 'http://127.0.0.1:9100/api/code/bsTemplate/save', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 17:32:32', '2020-06-28 17:32:32');
INSERT INTO `t_sys_log` VALUES ('2156', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '47 ms', '2020-06-28 17:32:33', '2020-06-28 17:32:33');
INSERT INTO `t_sys_log` VALUES ('2157', '保存项目代码模板表', 'http://127.0.0.1:9100/api/code/bsTemplate/save', '127.0.0.1', '1', '200', '35 ms', '2020-06-28 17:32:42', '2020-06-28 17:32:42');
INSERT INTO `t_sys_log` VALUES ('2158', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '42 ms', '2020-06-28 17:32:43', '2020-06-28 17:32:43');
INSERT INTO `t_sys_log` VALUES ('2159', '保存项目代码模板表', 'http://127.0.0.1:9100/api/code/bsTemplate/save', '127.0.0.1', '1', '200', '116 ms', '2020-06-28 17:38:44', '2020-06-28 17:38:44');
INSERT INTO `t_sys_log` VALUES ('2160', '获取项目代码模板表列表分页', 'http://127.0.0.1:9100/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '58 ms', '2020-06-28 17:38:44', '2020-06-28 17:38:44');
INSERT INTO `t_sys_log` VALUES ('2161', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '21 ms', '2020-06-28 17:42:06', '2020-06-28 17:42:06');
INSERT INTO `t_sys_log` VALUES ('2162', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 17:42:06', '2020-06-28 17:42:06');
INSERT INTO `t_sys_log` VALUES ('2163', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 17:42:08', '2020-06-28 17:42:08');
INSERT INTO `t_sys_log` VALUES ('2164', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '84 ms', '2020-06-28 17:42:10', '2020-06-28 17:42:10');
INSERT INTO `t_sys_log` VALUES ('2165', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '188234 ms', '2020-06-28 17:48:12', '2020-06-28 17:48:12');
INSERT INTO `t_sys_log` VALUES ('2166', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '3730 ms', '2020-06-28 17:48:19', '2020-06-28 17:48:19');
INSERT INTO `t_sys_log` VALUES ('2167', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 17:48:22', '2020-06-28 17:48:22');
INSERT INTO `t_sys_log` VALUES ('2168', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '229 ms', '2020-06-28 17:48:23', '2020-06-28 17:48:23');
INSERT INTO `t_sys_log` VALUES ('2169', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '99523 ms', '2020-06-28 17:50:06', '2020-06-28 17:50:06');
INSERT INTO `t_sys_log` VALUES ('2170', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '19 ms', '2020-06-28 17:50:14', '2020-06-28 17:50:14');
INSERT INTO `t_sys_log` VALUES ('2171', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 17:50:14', '2020-06-28 17:50:14');
INSERT INTO `t_sys_log` VALUES ('2172', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '13 ms', '2020-06-28 17:50:16', '2020-06-28 17:50:16');
INSERT INTO `t_sys_log` VALUES ('2173', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '48 ms', '2020-06-28 17:50:16', '2020-06-28 17:50:16');
INSERT INTO `t_sys_log` VALUES ('2174', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '36 ms', '2020-06-28 17:50:18', '2020-06-28 17:50:18');
INSERT INTO `t_sys_log` VALUES ('2175', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '22 ms', '2020-06-28 17:50:21', '2020-06-28 17:50:21');
INSERT INTO `t_sys_log` VALUES ('2176', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '40 ms', '2020-06-28 17:50:21', '2020-06-28 17:50:21');
INSERT INTO `t_sys_log` VALUES ('2177', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 17:50:23', '2020-06-28 17:50:23');
INSERT INTO `t_sys_log` VALUES ('2178', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '29 ms', '2020-06-28 17:50:29', '2020-06-28 17:50:29');
INSERT INTO `t_sys_log` VALUES ('2179', '保存数据库信息表', 'http://127.0.0.1:9100/api/code/database/save', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 17:50:52', '2020-06-28 17:50:52');
INSERT INTO `t_sys_log` VALUES ('2180', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 17:50:52', '2020-06-28 17:50:52');
INSERT INTO `t_sys_log` VALUES ('2181', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 17:50:56', '2020-06-28 17:50:56');
INSERT INTO `t_sys_log` VALUES ('2182', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 17:52:02', '2020-06-28 17:52:02');
INSERT INTO `t_sys_log` VALUES ('2183', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '92 ms', '2020-06-28 17:52:04', '2020-06-28 17:52:04');
INSERT INTO `t_sys_log` VALUES ('2184', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '14 ms', '2020-06-28 17:52:06', '2020-06-28 17:52:06');
INSERT INTO `t_sys_log` VALUES ('2185', '获取项目代码模板列表分页', 'http://127.0.0.1:9100/api/code/project_template/listPage', '127.0.0.1', '1', '200', '47 ms', '2020-06-28 17:52:06', '2020-06-28 17:52:06');
INSERT INTO `t_sys_log` VALUES ('2186', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '39 ms', '2020-06-28 17:52:08', '2020-06-28 17:52:08');
INSERT INTO `t_sys_log` VALUES ('2187', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 17:52:11', '2020-06-28 17:52:11');
INSERT INTO `t_sys_log` VALUES ('2188', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 17:52:11', '2020-06-28 17:52:11');
INSERT INTO `t_sys_log` VALUES ('2189', '保存数据库信息表', 'http://127.0.0.1:9100/api/code/database/save', '127.0.0.1', '1', '200', '32 ms', '2020-06-28 17:52:19', '2020-06-28 17:52:19');
INSERT INTO `t_sys_log` VALUES ('2190', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 17:52:19', '2020-06-28 17:52:19');
INSERT INTO `t_sys_log` VALUES ('2191', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 17:52:24', '2020-06-28 17:52:24');
INSERT INTO `t_sys_log` VALUES ('2192', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 17:52:25', '2020-06-28 17:52:25');
INSERT INTO `t_sys_log` VALUES ('2193', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '9 ms', '2020-06-28 17:52:27', '2020-06-28 17:52:27');
INSERT INTO `t_sys_log` VALUES ('2194', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-06-28 17:52:27', '2020-06-28 17:52:27');
INSERT INTO `t_sys_log` VALUES ('2195', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '28 ms', '2020-06-28 17:52:36', '2020-06-28 17:52:36');
INSERT INTO `t_sys_log` VALUES ('2196', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9100/api/code/project/list', '127.0.0.1', '1', '200', '17 ms', '2020-06-28 17:52:39', '2020-06-28 17:52:39');
INSERT INTO `t_sys_log` VALUES ('2197', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '29 ms', '2020-06-28 17:52:39', '2020-06-28 17:52:39');
INSERT INTO `t_sys_log` VALUES ('2198', '保存数据库信息表', 'http://127.0.0.1:9100/api/code/database/save', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 17:52:43', '2020-06-28 17:52:43');
INSERT INTO `t_sys_log` VALUES ('2199', '获取数据库信息表列表分页', 'http://127.0.0.1:9100/api/code/database/listPage', '127.0.0.1', '1', '200', '30 ms', '2020-06-28 17:52:43', '2020-06-28 17:52:43');
INSERT INTO `t_sys_log` VALUES ('2200', '获取数据表', 'http://127.0.0.1:9100/api/code/database/tableList', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 17:52:45', '2020-06-28 17:52:45');
INSERT INTO `t_sys_log` VALUES ('2201', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '36 ms', '2020-06-28 17:52:47', '2020-06-28 17:52:47');
INSERT INTO `t_sys_log` VALUES ('2202', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '12163 ms', '2020-06-28 17:53:04', '2020-06-28 17:53:04');
INSERT INTO `t_sys_log` VALUES ('2203', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '5458 ms', '2020-06-28 17:55:17', '2020-06-28 17:55:17');
INSERT INTO `t_sys_log` VALUES ('2204', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '49 ms', '2020-06-28 17:55:19', '2020-06-28 17:55:19');
INSERT INTO `t_sys_log` VALUES ('2205', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '73 ms', '2020-06-28 17:55:20', '2020-06-28 17:55:20');
INSERT INTO `t_sys_log` VALUES ('2206', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '513 ms', '2020-06-28 18:06:39', '2020-06-28 18:06:39');
INSERT INTO `t_sys_log` VALUES ('2207', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '209 ms', '2020-06-28 18:06:41', '2020-06-28 18:06:41');
INSERT INTO `t_sys_log` VALUES ('2208', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '8316 ms', '2020-06-28 18:06:53', '2020-06-28 18:06:53');
INSERT INTO `t_sys_log` VALUES ('2209', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '19 ms', '2020-06-28 18:06:54', '2020-06-28 18:06:54');
INSERT INTO `t_sys_log` VALUES ('2210', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '56 ms', '2020-06-28 18:06:54', '2020-06-28 18:06:54');
INSERT INTO `t_sys_log` VALUES ('2211', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '85 ms', '2020-06-28 18:09:52', '2020-06-28 18:09:52');
INSERT INTO `t_sys_log` VALUES ('2212', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '407 ms', '2020-06-28 18:09:59', '2020-06-28 18:09:59');
INSERT INTO `t_sys_log` VALUES ('2213', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 18:10:02', '2020-06-28 18:10:02');
INSERT INTO `t_sys_log` VALUES ('2214', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '28 ms', '2020-06-28 18:10:02', '2020-06-28 18:10:02');
INSERT INTO `t_sys_log` VALUES ('2215', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '386 ms', '2020-06-28 18:10:04', '2020-06-28 18:10:04');
INSERT INTO `t_sys_log` VALUES ('2216', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 18:10:06', '2020-06-28 18:10:06');
INSERT INTO `t_sys_log` VALUES ('2217', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '59 ms', '2020-06-28 18:10:07', '2020-06-28 18:10:07');
INSERT INTO `t_sys_log` VALUES ('2218', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '361 ms', '2020-06-28 18:10:10', '2020-06-28 18:10:10');
INSERT INTO `t_sys_log` VALUES ('2219', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '25 ms', '2020-06-28 18:10:11', '2020-06-28 18:10:11');
INSERT INTO `t_sys_log` VALUES ('2220', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '40 ms', '2020-06-28 18:10:12', '2020-06-28 18:10:12');
INSERT INTO `t_sys_log` VALUES ('2221', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '357 ms', '2020-06-28 18:10:14', '2020-06-28 18:10:14');
INSERT INTO `t_sys_log` VALUES ('2222', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '20 ms', '2020-06-28 18:10:15', '2020-06-28 18:10:15');
INSERT INTO `t_sys_log` VALUES ('2223', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '23 ms', '2020-06-28 18:10:16', '2020-06-28 18:10:16');
INSERT INTO `t_sys_log` VALUES ('2224', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '37 ms', '2020-06-28 18:17:46', '2020-06-28 18:17:46');
INSERT INTO `t_sys_log` VALUES ('2225', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '161 ms', '2020-06-28 18:19:47', '2020-06-28 18:19:47');
INSERT INTO `t_sys_log` VALUES ('2226', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '212 ms', '2020-06-28 18:19:48', '2020-06-28 18:19:48');
INSERT INTO `t_sys_log` VALUES ('2227', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '203 ms', '2020-06-28 18:23:00', '2020-06-28 18:23:00');
INSERT INTO `t_sys_log` VALUES ('2228', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '196 ms', '2020-06-28 18:23:01', '2020-06-28 18:23:01');
INSERT INTO `t_sys_log` VALUES ('2229', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '1398 ms', '2020-06-28 18:23:09', '2020-06-28 18:23:09');
INSERT INTO `t_sys_log` VALUES ('2230', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '45 ms', '2020-06-28 18:23:11', '2020-06-28 18:23:11');
INSERT INTO `t_sys_log` VALUES ('2231', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '34 ms', '2020-06-28 18:23:11', '2020-06-28 18:23:11');
INSERT INTO `t_sys_log` VALUES ('2232', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '66 ms', '2020-06-28 18:25:18', '2020-06-28 18:25:18');
INSERT INTO `t_sys_log` VALUES ('2233', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '32 ms', '2020-06-28 18:25:19', '2020-06-28 18:25:19');
INSERT INTO `t_sys_log` VALUES ('2234', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-06-28 18:25:58', '2020-06-28 18:25:58');
INSERT INTO `t_sys_log` VALUES ('2235', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 18:25:58', '2020-06-28 18:25:58');
INSERT INTO `t_sys_log` VALUES ('2236', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '396 ms', '2020-06-28 18:26:09', '2020-06-28 18:26:09');
INSERT INTO `t_sys_log` VALUES ('2237', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-06-28 18:26:10', '2020-06-28 18:26:10');
INSERT INTO `t_sys_log` VALUES ('2238', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '41 ms', '2020-06-28 18:26:11', '2020-06-28 18:26:11');
INSERT INTO `t_sys_log` VALUES ('2239', '获取当前登录用户信息', 'http://127.0.0.1:9100/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '27 ms', '2020-06-28 18:26:52', '2020-06-28 18:26:52');
INSERT INTO `t_sys_log` VALUES ('2240', '表字段列表', 'http://127.0.0.1:9100/api/code/database/columnList', '127.0.0.1', '1', '200', '52 ms', '2020-06-28 18:26:52', '2020-06-28 18:26:52');
INSERT INTO `t_sys_log` VALUES ('2241', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '324 ms', '2020-06-28 18:26:58', '2020-06-28 18:26:58');
INSERT INTO `t_sys_log` VALUES ('2242', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '838 ms', '2020-06-28 18:32:02', '2020-06-28 18:32:02');
INSERT INTO `t_sys_log` VALUES ('2243', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '1131 ms', '2020-06-28 18:33:54', '2020-06-28 18:33:54');
INSERT INTO `t_sys_log` VALUES ('2244', '生成代码', 'http://127.0.0.1:9100/api/code/project/generate', '127.0.0.1', '1', '200', '1311 ms', '2020-06-28 18:36:50', '2020-06-28 18:36:50');

-- ----------------------------
-- Table structure for t_sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_menu`;
CREATE TABLE `t_sys_menu` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '上级资源ID',
  `url` varchar(255) DEFAULT NULL COMMENT 'url',
  `resources` varchar(255) DEFAULT NULL COMMENT '资源编码',
  `title` varchar(100) DEFAULT NULL COMMENT '资源名称',
  `level` int(11) DEFAULT NULL COMMENT '资源级别',
  `sort_no` int(11) DEFAULT NULL COMMENT '排序',
  `icon` varchar(32) DEFAULT NULL COMMENT '资源图标',
  `type` varchar(32) DEFAULT NULL COMMENT '类型 menu、button',
  `remarks` varchar(500) DEFAULT NULL COMMENT '备注',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理-权限资源表 ';

-- ----------------------------
-- Records of t_sys_menu
-- ----------------------------
INSERT INTO `t_sys_menu` VALUES ('1', '0', null, 'systemManage', '系统管理', '1', '3', 'component', 'menu', '', '2019-03-28 18:51:08', '2019-03-28 18:51:10');
INSERT INTO `t_sys_menu` VALUES ('2', '1', '/system/user/listPage', 'user', '用户管理', '2', '1', 'my-user', 'menu', '', '2019-03-28 18:52:13', '2019-08-31 21:26:57');
INSERT INTO `t_sys_menu` VALUES ('3', '2', null, 'sys:user:add', '添加', '3', '1', 'el-icon-edit', 'button', '', '2019-03-28 18:53:31', '2019-04-01 20:19:55');
INSERT INTO `t_sys_menu` VALUES ('4', '2', null, 'sys:user:edit', '编辑', '3', '2', null, 'button', '', '2019-03-28 18:54:26', '2019-04-01 20:20:16');
INSERT INTO `t_sys_menu` VALUES ('5', '2', '/system/user/delete', 'sys:user:delete', '删除', '3', '3', null, 'button', '', '2019-03-28 18:55:25', '2019-04-01 20:20:09');
INSERT INTO `t_sys_menu` VALUES ('13', '0', null, 'codeGenerator', '代码生成器', '1', '2', 'table', 'menu', '', '2019-03-30 13:54:43', '2019-09-07 21:06:55');
INSERT INTO `t_sys_menu` VALUES ('15', '13', '/code/project/listPage', 'project', '项目管理', '1', '1', 'icon-news', 'menu', '', '2019-03-30 13:58:00', '2019-09-01 15:01:58');
INSERT INTO `t_sys_menu` VALUES ('16', '1', '/system/role/listPage', 'role', '角色管理', '2', '2', 'my-role', 'menu', '', '2019-03-30 14:00:03', '2019-03-30 14:20:59');
INSERT INTO `t_sys_menu` VALUES ('17', '1', '/system/menu/treeMenu', 'menu', '菜单管理', '2', '3', 'my-sysmenu', 'menu', '', '2019-03-30 14:00:53', '2019-03-30 14:21:10');
INSERT INTO `t_sys_menu` VALUES ('43', '16', null, 'sys:role:add', '添加', '3', '1', '', 'button', '', '2019-04-01 20:20:46', '2019-04-01 20:20:46');
INSERT INTO `t_sys_menu` VALUES ('44', '16', null, 'sys:role:edit', '编辑', '3', '2', '', 'button', '', '2019-04-01 20:21:03', '2019-04-01 20:21:03');
INSERT INTO `t_sys_menu` VALUES ('45', '16', null, 'roleSetting', '权限设置', '3', '3', '', 'button', '', '2019-04-01 20:21:24', '2019-04-01 20:21:24');
INSERT INTO `t_sys_menu` VALUES ('46', '16', '/system/role/delete', 'sys:role:delete', '删除', '3', '4', '', 'button', '', '2019-04-01 20:21:55', '2019-04-01 20:21:55');
INSERT INTO `t_sys_menu` VALUES ('47', '17', '', 'sys:menu:add', '添加', '3', '1', '', 'button', '', '2019-04-01 20:22:31', '2019-04-01 20:22:31');
INSERT INTO `t_sys_menu` VALUES ('48', '17', null, 'sys:menu:addsub', '添加下级', '3', '2', '', 'button', '', '2019-04-01 20:23:00', '2019-04-01 20:23:00');
INSERT INTO `t_sys_menu` VALUES ('49', '17', null, 'sys:menu:edit', '编辑', '3', '3', '', 'button', '', '2019-04-01 20:23:28', '2019-04-01 20:23:28');
INSERT INTO `t_sys_menu` VALUES ('50', '17', '/system/menu/delete', 'sys:menu:delete', '删除', '3', '4', '', 'button', '', '2019-04-01 20:23:46', '2019-04-01 20:23:46');
INSERT INTO `t_sys_menu` VALUES ('53', '13', '/code/bsTemplate/listPage', 'bs_template', '初始模板', '2', '2', 'icon-news', 'menu', null, '2019-09-01 15:01:42', '2019-09-01 15:02:05');
INSERT INTO `t_sys_menu` VALUES ('54', '13', '/code/project_template/listPage', 'project_template', '项目模板管理', '3', '3', 'documentation', 'menu', null, '2019-09-01 15:03:02', '2019-09-01 15:03:02');
INSERT INTO `t_sys_menu` VALUES ('55', '13', '/code/database/listPage', 'database', '数据库管理', '4', '4', 'icon-news', 'menu', null, '2019-09-01 15:04:09', '2019-09-01 15:11:25');
INSERT INTO `t_sys_menu` VALUES ('56', '55', '/code/database/tableList', 'table', '是否显示数据库表', '3', '4', null, 'button', null, '2019-09-01 15:10:34', '2019-09-13 03:27:56');
INSERT INTO `t_sys_menu` VALUES ('57', '55', '/code/database/columnList', 'column', '是否显示数据表字段信息', '3', '5', null, 'button', null, '2019-09-01 15:11:12', '2019-09-13 03:38:31');
INSERT INTO `t_sys_menu` VALUES ('59', '15', null, 'code:project:add', '新建一个项目', '3', '1', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('60', '15', null, 'code:project:edit', '编辑项目', '3', '2', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('61', '15', null, 'code:projectPackage:showTree', '是否显示项目树形包', '3', '3', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('62', '15', null, 'code:project:delete', '删除项目', '3', '4', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('63', '15', null, 'code:projectPackage:add', '添加项目包', '2', '5', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('64', '15', null, 'code:projectPackage:edit', '编辑项目包', '2', '6', null, 'button', null, '2019-09-12 11:19:49', '2019-09-12 11:19:49');
INSERT INTO `t_sys_menu` VALUES ('65', '15', null, 'code:projectPackage:delete', '删除项目包', '2', '7', null, 'button', null, '2019-09-12 11:22:18', '2019-09-12 11:22:18');
INSERT INTO `t_sys_menu` VALUES ('66', '54', null, 'code:projectTemplate:add', '添加项目模板', '4', '1', null, 'button', null, '2019-09-12 22:24:14', '2019-09-12 22:24:14');
INSERT INTO `t_sys_menu` VALUES ('67', '54', null, 'code:projectTemplate:delete', '删除项目模板', '4', '2', null, 'button', null, '2019-09-12 22:25:26', '2019-09-12 22:25:26');
INSERT INTO `t_sys_menu` VALUES ('68', '54', null, 'code:projectTemplate:edit', '编辑项目模板', '4', '3', null, 'button', null, '2019-09-12 22:27:15', '2019-09-12 22:27:15');
INSERT INTO `t_sys_menu` VALUES ('69', '53', null, 'code:bsTemplate:add', '添加初始模板', '3', '1', null, 'button', null, '2019-09-12 22:53:00', '2019-09-12 22:53:00');
INSERT INTO `t_sys_menu` VALUES ('70', '53', null, 'code:bsTemplate:edit', '编辑初始模板', '3', '2', null, 'button', null, '2019-09-12 22:53:49', '2019-09-12 22:53:49');
INSERT INTO `t_sys_menu` VALUES ('71', '53', null, 'code:bsTemplate:delete', '删除初始模板', '3', '3', null, 'button', null, '2019-09-12 22:54:34', '2019-09-12 22:54:34');
INSERT INTO `t_sys_menu` VALUES ('72', '55', null, 'code:database:add', '添加数据库信息', '5', '1', null, 'button', null, '2019-09-13 03:20:45', '2019-09-13 03:21:17');
INSERT INTO `t_sys_menu` VALUES ('73', '55', null, 'code:database:edit', '编辑数据库信息', '5', '2', null, 'button', null, '2019-09-13 03:28:25', '2019-09-13 03:28:25');
INSERT INTO `t_sys_menu` VALUES ('74', '55', null, 'code:database:delete', '删除数据库', '5', '3', null, 'button', null, '2019-09-13 03:28:53', '2019-09-13 03:28:53');
INSERT INTO `t_sys_menu` VALUES ('75', '55', null, 'code:column:update', '修改表字段信息', '5', '6', null, 'button', null, '2019-09-13 03:41:46', '2019-09-13 03:41:46');
INSERT INTO `t_sys_menu` VALUES ('76', '55', null, 'generateCode', '生成代码', '5', '7', null, 'button', null, '2019-09-13 03:45:12', '2019-09-13 03:45:12');
INSERT INTO `t_sys_menu` VALUES ('77', '54', null, 'code:projectTemplate:showVelocityContext', '是否显示参考模板数据源配置信息', '4', '4', null, 'button', '是否显示参考模板数据源配置信息', '2019-09-17 17:45:09', '2019-09-17 17:45:09');
INSERT INTO `t_sys_menu` VALUES ('78', '54', null, 'code:projectTemplate:generateTemplate', '生成项目模板', '4', '5', null, 'button', '生成项目模板', '2019-09-17 17:46:12', '2019-09-17 17:46:12');
INSERT INTO `t_sys_menu` VALUES ('79', '1', '/system/log', 'log', '系统日志', '2', '4', 'my-sysmenu', 'menu', '', '2019-03-30 14:00:53', '2019-09-18 14:21:38');
INSERT INTO `t_sys_menu` VALUES ('80', '2', '/system/user/updatePersonalInfo', 'sys:user:editPersonalInfo', '修改个人信息', '3', '4', null, 'button', null, '2019-09-18 21:05:51', '2019-09-18 22:40:45');

-- ----------------------------
-- Table structure for t_sys_role
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_role`;
CREATE TABLE `t_sys_role` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(50) DEFAULT NULL COMMENT '角色编码',
  `name` varchar(50) DEFAULT NULL COMMENT '角色名称',
  `remarks` varchar(500) DEFAULT NULL COMMENT '角色描述',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理-角色表 ';

-- ----------------------------
-- Records of t_sys_role
-- ----------------------------
INSERT INTO `t_sys_role` VALUES ('1', 'admin', '系统管理员', '系统管理员', '2019-03-28 15:51:56', '2019-03-28 15:51:59');
INSERT INTO `t_sys_role` VALUES ('2', 'visitor', '访客', '访客', '2019-03-28 20:17:04', '2019-09-09 16:32:15');

-- ----------------------------
-- Table structure for t_sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_role_menu`;
CREATE TABLE `t_sys_role_menu` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int(10) DEFAULT NULL COMMENT '角色ID',
  `menu_id` int(10) DEFAULT NULL COMMENT '菜单ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1578 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理 - 角色-权限资源关联表 ';

-- ----------------------------
-- Records of t_sys_role_menu
-- ----------------------------
INSERT INTO `t_sys_role_menu` VALUES ('1507', '1', '13', '2019-09-18 21:06:23', '2019-09-18 21:06:23');
INSERT INTO `t_sys_role_menu` VALUES ('1508', '1', '15', '2019-09-18 21:06:23', '2019-09-18 21:06:23');
INSERT INTO `t_sys_role_menu` VALUES ('1509', '1', '59', '2019-09-18 21:06:23', '2019-09-18 21:06:23');
INSERT INTO `t_sys_role_menu` VALUES ('1510', '1', '60', '2019-09-18 21:06:23', '2019-09-18 21:06:23');
INSERT INTO `t_sys_role_menu` VALUES ('1511', '1', '61', '2019-09-18 21:06:24', '2019-09-18 21:06:24');
INSERT INTO `t_sys_role_menu` VALUES ('1512', '1', '62', '2019-09-18 21:06:24', '2019-09-18 21:06:24');
INSERT INTO `t_sys_role_menu` VALUES ('1513', '1', '63', '2019-09-18 21:06:24', '2019-09-18 21:06:24');
INSERT INTO `t_sys_role_menu` VALUES ('1514', '1', '64', '2019-09-18 21:06:24', '2019-09-18 21:06:24');
INSERT INTO `t_sys_role_menu` VALUES ('1515', '1', '65', '2019-09-18 21:06:24', '2019-09-18 21:06:24');
INSERT INTO `t_sys_role_menu` VALUES ('1516', '1', '53', '2019-09-18 21:06:24', '2019-09-18 21:06:24');
INSERT INTO `t_sys_role_menu` VALUES ('1517', '1', '69', '2019-09-18 21:06:24', '2019-09-18 21:06:24');
INSERT INTO `t_sys_role_menu` VALUES ('1518', '1', '70', '2019-09-18 21:06:24', '2019-09-18 21:06:24');
INSERT INTO `t_sys_role_menu` VALUES ('1519', '1', '71', '2019-09-18 21:06:25', '2019-09-18 21:06:25');
INSERT INTO `t_sys_role_menu` VALUES ('1520', '1', '54', '2019-09-18 21:06:25', '2019-09-18 21:06:25');
INSERT INTO `t_sys_role_menu` VALUES ('1521', '1', '66', '2019-09-18 21:06:25', '2019-09-18 21:06:25');
INSERT INTO `t_sys_role_menu` VALUES ('1522', '1', '67', '2019-09-18 21:06:25', '2019-09-18 21:06:25');
INSERT INTO `t_sys_role_menu` VALUES ('1523', '1', '68', '2019-09-18 21:06:25', '2019-09-18 21:06:25');
INSERT INTO `t_sys_role_menu` VALUES ('1524', '1', '77', '2019-09-18 21:06:25', '2019-09-18 21:06:25');
INSERT INTO `t_sys_role_menu` VALUES ('1525', '1', '78', '2019-09-18 21:06:25', '2019-09-18 21:06:25');
INSERT INTO `t_sys_role_menu` VALUES ('1526', '1', '55', '2019-09-18 21:06:25', '2019-09-18 21:06:25');
INSERT INTO `t_sys_role_menu` VALUES ('1527', '1', '72', '2019-09-18 21:06:26', '2019-09-18 21:06:26');
INSERT INTO `t_sys_role_menu` VALUES ('1528', '1', '73', '2019-09-18 21:06:26', '2019-09-18 21:06:26');
INSERT INTO `t_sys_role_menu` VALUES ('1529', '1', '74', '2019-09-18 21:06:26', '2019-09-18 21:06:26');
INSERT INTO `t_sys_role_menu` VALUES ('1530', '1', '56', '2019-09-18 21:06:26', '2019-09-18 21:06:26');
INSERT INTO `t_sys_role_menu` VALUES ('1531', '1', '57', '2019-09-18 21:06:26', '2019-09-18 21:06:26');
INSERT INTO `t_sys_role_menu` VALUES ('1532', '1', '75', '2019-09-18 21:06:26', '2019-09-18 21:06:26');
INSERT INTO `t_sys_role_menu` VALUES ('1533', '1', '76', '2019-09-18 21:06:26', '2019-09-18 21:06:26');
INSERT INTO `t_sys_role_menu` VALUES ('1534', '1', '1', '2019-09-18 21:06:26', '2019-09-18 21:06:26');
INSERT INTO `t_sys_role_menu` VALUES ('1535', '1', '2', '2019-09-18 21:06:27', '2019-09-18 21:06:27');
INSERT INTO `t_sys_role_menu` VALUES ('1536', '1', '3', '2019-09-18 21:06:27', '2019-09-18 21:06:27');
INSERT INTO `t_sys_role_menu` VALUES ('1537', '1', '4', '2019-09-18 21:06:27', '2019-09-18 21:06:27');
INSERT INTO `t_sys_role_menu` VALUES ('1538', '1', '5', '2019-09-18 21:06:27', '2019-09-18 21:06:27');
INSERT INTO `t_sys_role_menu` VALUES ('1539', '1', '80', '2019-09-18 21:06:27', '2019-09-18 21:06:27');
INSERT INTO `t_sys_role_menu` VALUES ('1540', '1', '16', '2019-09-18 21:06:27', '2019-09-18 21:06:27');
INSERT INTO `t_sys_role_menu` VALUES ('1541', '1', '43', '2019-09-18 21:06:27', '2019-09-18 21:06:27');
INSERT INTO `t_sys_role_menu` VALUES ('1542', '1', '44', '2019-09-18 21:06:27', '2019-09-18 21:06:27');
INSERT INTO `t_sys_role_menu` VALUES ('1543', '1', '45', '2019-09-18 21:06:28', '2019-09-18 21:06:28');
INSERT INTO `t_sys_role_menu` VALUES ('1544', '1', '46', '2019-09-18 21:06:28', '2019-09-18 21:06:28');
INSERT INTO `t_sys_role_menu` VALUES ('1545', '1', '17', '2019-09-18 21:06:28', '2019-09-18 21:06:28');
INSERT INTO `t_sys_role_menu` VALUES ('1546', '1', '47', '2019-09-18 21:06:28', '2019-09-18 21:06:28');
INSERT INTO `t_sys_role_menu` VALUES ('1547', '1', '48', '2019-09-18 21:06:28', '2019-09-18 21:06:28');
INSERT INTO `t_sys_role_menu` VALUES ('1548', '1', '49', '2019-09-18 21:06:28', '2019-09-18 21:06:28');
INSERT INTO `t_sys_role_menu` VALUES ('1549', '1', '50', '2019-09-18 21:06:28', '2019-09-18 21:06:28');
INSERT INTO `t_sys_role_menu` VALUES ('1550', '1', '79', '2019-09-18 21:06:28', '2019-09-18 21:06:28');
INSERT INTO `t_sys_role_menu` VALUES ('1551', '2', '13', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1552', '2', '15', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1553', '2', '59', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1554', '2', '60', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1555', '2', '61', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1556', '2', '62', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1557', '2', '63', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1558', '2', '64', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1559', '2', '65', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1560', '2', '53', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1561', '2', '69', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1562', '2', '70', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1563', '2', '71', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1564', '2', '54', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1565', '2', '66', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1566', '2', '67', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1567', '2', '68', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1568', '2', '77', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1569', '2', '78', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1570', '2', '55', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1571', '2', '72', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1572', '2', '73', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1573', '2', '56', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1574', '2', '57', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1575', '2', '75', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1576', '2', '76', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1577', '2', '80', '2019-09-18 21:26:45', '2019-09-18 21:26:45');

-- ----------------------------
-- Table structure for t_sys_user
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_user`;
CREATE TABLE `t_sys_user` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(100) DEFAULT NULL COMMENT '账号',
  `password` varchar(100) DEFAULT NULL COMMENT '登录密码',
  `nick_name` varchar(50) DEFAULT NULL COMMENT '昵称',
  `sex` varchar(1) DEFAULT NULL COMMENT '性别 0:男 1:女',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `flag` varchar(1) DEFAULT NULL COMMENT '状态',
  `salt` varchar(50) DEFAULT NULL COMMENT '盐值',
  `token` varchar(100) DEFAULT NULL COMMENT 'token',
  `qq_oppen_id` varchar(100) DEFAULT NULL COMMENT 'QQ 第三方登录Oppen_ID唯一标识',
  `pwd` varchar(100) DEFAULT NULL COMMENT '明文密码',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理-用户基础信息表';

-- ----------------------------
-- Records of t_sys_user
-- ----------------------------
INSERT INTO `t_sys_user` VALUES ('1', 'admin', '0ad1be0abfc90ee593f2a68d3193afedf15fc9141382f6e1492c0629ed6263ac', '管理员', '0', '15183303003', '10086@qq.com', 'http://qzapp.qlogo.cn/qzapp/101536330/86F96F92387D69BD7659C4EC3CD6BD69/100', '1', '123', 'code-generator_token_280df316-92ef-4bfb-859a-1b1510e4f627', '', '123456', '2019-05-05 16:09:06', '2020-06-28 17:30:27');
INSERT INTO `t_sys_user` VALUES ('2', 'test', '0ad1be0abfc90ee593f2a68d3193afedf15fc9141382f6e1492c0629ed6263ac', '测试号', '0', '10000', '10000@qq.com', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', '1', '123', 'code-generator_token_fd278eac-0e2d-4d15-afef-81ed8f3323ae', null, '123456', '2019-05-05 16:15:06', '2020-06-28 15:41:39');

-- ----------------------------
-- Table structure for t_sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_user_role`;
CREATE TABLE `t_sys_user_role` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int(10) DEFAULT NULL COMMENT '角色ID',
  `user_id` int(10) DEFAULT NULL COMMENT '用户ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理 - 用户角色关联表 ';

-- ----------------------------
-- Records of t_sys_user_role
-- ----------------------------
INSERT INTO `t_sys_user_role` VALUES ('12', '1', '1', '2019-08-21 10:49:41', '2019-08-21 10:49:41');
INSERT INTO `t_sys_user_role` VALUES ('33', '2', '2', '2019-09-18 21:26:32', '2019-09-18 21:26:32');
