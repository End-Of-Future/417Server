--王牌竞赛 魔炮
function c88880546.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c88880546.ffilter,3,true) 
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c88880546.hspcon)
	e1:SetOperation(c88880546.hspop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION end) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)
	--disable search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	c:RegisterEffect(e1)	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c88880546.reptg)
	c:RegisterEffect(e2)
end
function c88880546.ffilter(c)
	return c:IsFusionSetCard(0xd88) 
end 
function c88880546.rmfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xd88) 
end 
function c88880546.rmgck(g,e,tp) 
	return Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0  
end 
function c88880546.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c88880546.rmfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(c88880546.rmgck,3,3,e,tp)
end
function c88880546.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c88880546.rmfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil) 
	local sg=g:SelectSubGroup(tp,c88880546.rmgck,false,3,3,e,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c88880546.repfilter(c)
	return c:IsSetCard(0xd88) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c88880546.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c88880546.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c88880546.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end






