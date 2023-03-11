--超高校级•绝望
function c88882107.initial_effect(c)
	c:SetSPSummonOnce(88882107)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c88882107.lcheck)
	c:EnableReviveLimit()   
	--draw count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c88882107.drcon)
	e1:SetValue(c88882107.drval)
	c:RegisterEffect(e1)  
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c88882107.aclimit)
	c:RegisterEffect(e2) 
	--atk up 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c88882107.tgtg)
	e3:SetValue(500)
	c:RegisterEffect(e3) 
end
c88882107.ACGXJre=true  
function c88882107.lcckfil(c) 
	return c.ACGXJre   
end 
function c88882107.lcheck(g)
	return g:IsExists(c88882107.lcckfil,1,nil)
end 
function c88882107.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x112) and c:GetMutualLinkedGroupCount()>0
end
function c88882107.drcon(e)
	return Duel.GetMatchingGroupCount(c88882107.drfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)>0
end
function c88882107.drval(e)
	local g=Duel.GetMatchingGroup(c88882107.drfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetClassCount(Card.GetCode)
end
function c88882107.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsSummonType(SUMMON_TYPE_SPECIAL) and not tc:IsLinkState() and re:IsActiveType(TYPE_MONSTER)
end
function c88882107.tgtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end










