--激流海灵龙
function c27822021.initial_effect(c) 
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27822021,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,27822021)
	e1:SetCondition(c27822021.negcon)
	e1:SetCost(c27822021.negcost)
	e1:SetTarget(c27822021.negtg)
	e1:SetOperation(c27822021.negop)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,17822021+EFFECT_COUNT_CODE_DUEL)  
	e2:SetTarget(c27822021.sptg) 
	e2:SetOperation(c27822021.spop) 
	c:RegisterEffect(e2) 
end
c27822021.XXSplash=true  
function c27822021.negcon(e,tp,eg,ep,ev,re,r,rp) 
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp 
		and Duel.IsChainNegatable(ev)
end
function c27822021.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c27822021.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27822021.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end 
function c27822021.tdfil(c) 
	return c:IsType(TYPE_LINK) and c.XXSplash and c:IsAbleToDeck()   
end  
function c27822021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27822021.tdfil,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end   
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end  
function c27822021.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27822021.tdfil,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)  
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
	end 
end 



