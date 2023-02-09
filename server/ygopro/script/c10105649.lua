function c10105649.initial_effect(c)
	c:SetSPSummonOnce(10105649)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,4,c10105649.ovfilter,aux.Stringid(10105649,0),99,c10105649.xyzop)
	c:EnableReviveLimit()
        	--code
	aux.EnableChangeCode(c,13171876,LOCATION_MZONE+LOCATION_GRAVE)
    --repeat attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105649,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,10105649)
	e1:SetTarget(c10105649.thtg)
	e1:SetOperation(c10105649.thop)
	c:RegisterEffect(e1)
    	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105649,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101056490)
	e3:SetCondition(c10105649.discon)
	e3:SetCost(c10105649.discost)
	e3:SetTarget(c10105649.distg)
	e3:SetOperation(c10105649.disop)
	c:RegisterEffect(e3)
    end
function c10105649.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c10105649.cfilter(c)
	return c:IsSetCard(0x133) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c10105649.ovfilter(c)
	return c:IsFaceup() and c:IsCode(13171876)
end
function c10105649.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105649.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c10105649.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c10105649.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function c10105649.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10105649.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(CATEGORY_NEGATE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:GetHandler():IsRelateToEffect(re)
		and not re:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	end
end
function c10105649.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:GetHandler():IsRelateToEffect(re) and not re:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.BreakEffect()
		Duel.GetControl(re:GetHandler(),tp)
	end
end
function c10105649.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c10105649.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end