--激流飞龙
function c27822018.initial_effect(c) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c27822018.matfilter,2)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)	
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c27822018.sprcon)
	e2:SetOperation(c27822018.sprop)
	c:RegisterEffect(e2) 
	--Disable 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DISABLE) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e3:SetCountLimit(1,27822018) 
	e3:SetTarget(c27822018.distg)   
	e3:SetOperation(c27822018.disop) 
	c:RegisterEffect(e3) 
	--SpecialSummon 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_PHASE+PHASE_END) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1,17822018) 
	e4:SetTarget(c27822018.sptg) 
	e4:SetOperation(c27822018.spop) 
	c:RegisterEffect(e4) 
end  
c27822018.XXSplash=true 
function c27822018.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c27822018.sprfilter(c,tp,sc) 
	return c:IsCode(27822019) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0  
end
function c27822018.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c27822018.sprfilter,1,nil,tp,c)
end
function c27822018.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c27822018.sprfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end 
function c27822018.lkfil(c) 
	return c:IsType(TYPE_LINK) and c:IsLinkAbove(1)  
end 
function c27822018.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c27822018.lkfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.SelectTarget(tp,c27822018.lkfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,LOCATION_ONFIELD)
end 
function c27822018.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local lk=tc:GetLink() 
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 and lk>0 then 
		local dg=g:Select(tp,1,lk,nil) 
		local tc=dg:GetFirst() 
		while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext() 
		end 
	end 
end 
function c27822018.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and c:IsCode(27822019) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0   
end 
function c27822018.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) and e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c27822018.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end  
function c27822018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c27822018.spfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)~=0 and g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP) 
	end 
end 


