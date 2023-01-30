--孤独摇滚 后藤一里
local m=10700054
local cm=_G["c"..m]

function cm.initial_effect(c)
	function cm.AddLinkProcedure(c,f,min,max,gf,string)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(string)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		if max==nil then max=c:GetLink() end
		e1:SetCondition(Auxiliary.LinkCondition(f,min,max,gf))
		e1:SetTarget(Auxiliary.LinkTarget(f,min,max,gf))
		e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
		e1:SetValue(SUMMON_TYPE_LINK)
		c:RegisterEffect(e1)
		return e1
	end
	function cm.AddLinkProcedure2(c,f,min,max,gf,string)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(string)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		if max==nil then max=c:GetLink() end
		e1:SetCondition(cm.LinkCondition(f,min,max,gf))
		e1:SetTarget(cm.LinkTarget(f,min,max,gf))
		e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
		e1:SetValue(SUMMON_TYPE_LINK)
		c:RegisterEffect(e1)
		return e1
	end
	--link summon
	cm.AddLinkProcedure(c,cm.lfcheck,2,2,cm.lcheck,aux.Stringid(m,6))
	cm.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,2,cm.lcheck2,aux.Stringid(m,7))
	cm.AddLinkProcedure2(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),2,2,nil,aux.Stringid(m,8))
	c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --atk record
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+10700054)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.ad1op)
	c:RegisterEffect(e1)
	--atk check
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.ad2op)
	c:RegisterEffect(e2)
	local e10=e2:Clone()
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e10)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CUSTOM+10700055)
    e3:SetCountLimit(1,m)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--lpcheck
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.tgcon)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
    --imm
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    e5:SetCondition(cm.atkcon)
    c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(cm.atkcon)
	e6:SetValue(cm.efilter)
	c:RegisterEffect(e6)
	--atkup
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(cm.aucon1)
	e8:SetValue(cm.atkupfilter1)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(cm.aucon2)
	e9:SetValue(cm.atkupfilter2)
	c:RegisterEffect(e9)
end

function cm.lfcheck(c)
	return not c:IsLink(2)
end

function cm.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_DARK) or g:IsExists(Card.IsLinkRace,1,nil,RACE_PSYCHO)
end

function cm.lcheck2(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_SPIRIT)
end

function cm.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_HAND,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end

function cm.LinkCondition(f,minc,maxc,gf)
	return	function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=cm.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end

function cm.LinkTarget(f,minc,maxc,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=cm.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.ad1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(110700054)
	c:RegisterFlagEffect(110700054,RESET_EVENT+RESETS_STANDARD,0,1,c:GetAttack())
end

function cm.ad2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(110700054)==0 then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10700054,e,0,0,0,0)
	end
	if c:GetFlagEffectLabel(110700054)~=c:GetAttack() then
        if c:GetFlagEffectLabel(110700054)<(c:GetAttack()) then
		    Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10700055,e,0,0,0,0)
        end
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10700054,e,0,0,0,0)
	end
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:ResetFlagEffect(110700055)
        c:ResetFlagEffect(110700056)
        local num=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
        if num==0 then
            c:RegisterFlagEffect(110700055,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
        elseif num==1 then
            c:RegisterFlagEffect(110700056,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
        end
    end
end

function cm.atkupfilter1(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,0x02,0)*700
end

function cm.atkupfilter2(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,0x0c,0)*500
end

function cm.aucon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(110700055)~=0
end

function cm.aucon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(110700056)~=0
end

function cm.tgcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
    local g=Duel.GetFieldGroup(tp,0x04,0)
	return c:IsStatus(STATUS_EFFECT_ENABLED) and #g==g:FilterCount(Card.IsCode,nil,m) and c:GetAttack()<10000
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	Duel.Readjust()
end

function cm.atkcon(e)
	return e:GetHandler():GetAttack()>=10000
end

function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end